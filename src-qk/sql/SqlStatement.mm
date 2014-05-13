// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-types.h"
#import "NSArray+QK.h"
#import "NSString+QK.h"
#import "qk-sql-util.h"
#import "SqlDatabase.h"
#import "SqlStatement.h"


#define _CHECK(exp_code, fmt, ...) \
qk_check(code == exp_code, @"%@\n%@\n" fmt, sql_failure_str(_db.handle, code), self.query, ##__VA_ARGS__)

#define _ASSERT(exp_code, fmt, ...) \
qk_assert(code == exp_code, @"%@\n%@\n" fmt, sql_failure_str(_db.handle, code), self.query, ##__VA_ARGS__)

#define _CHECK_OK(...) _CHECK(SQLITE_OK, __VA_ARGS__)
#define _ASSERT_OK(...) _ASSERT(SQLITE_OK, __VA_ARGS__)


@interface SqlStatement ()

@property (nonatomic) sqlite3_stmt* handle;

@end


@implementation SqlStatement


- (void)dealloc {
  [self close];
}


DEF_INIT(Database:(SqlDatabase*)db query:(NSString*)query) {
  INIT(super init);
  _db = db;
  Utf8 tail = NULL;
  int code = sqlite3_prepare_v2(_db.handle, query.asUtf8, -1, &_handle, &tail);
  _CHECK_OK(@"prepare: %@", query);
  qk_assert(!*tail, @"prepared query has unused tail: '%s'", tail);
  return self;
}


- (void)close {
  int code = sqlite3_finalize(_handle);
  if (code != SQLITE_OK) {
    NSLog(@"SqlStatement close: %@\n%@", sql_failure_str(_db.handle, code), self.query);
  }
  _handle = NULL;
}


- (NSString*)query {
  return [NSString withUtf8:sqlite3_sql(_handle)];
}


- (void)reset {
  int code = sqlite3_reset(_handle);
  _CHECK_OK(@"reset");
}


- (int)columnCount {
  return sqlite3_column_count(_handle);
}


- (void)execute {
  int code = sqlite3_step(_handle);
  _CHECK(SQLITE_DONE, @"execute");
  [self reset];
}


- (BOOL)step {
  int code = sqlite3_step(_handle);
  if (code == SQLITE_ROW) {
    return YES;
  }
  _CHECK(SQLITE_DONE, @"step");
  return NO;
}


- (void)step1:(BlockStepSql)block {
  int code = sqlite3_step(_handle);
  _CHECK(SQLITE_ROW, @"step1: no rows");
  block(self);
  sqlite3_step(_handle);
  _CHECK(SQLITE_DONE, @"step1: multiple rows");
  [self reset];
}


#define STEP1(T) \
- (T)step1##T { \
int code = sqlite3_step(_handle); \
_CHECK(SQLITE_ROW, @"step1Int: no rows"); \
T val = self.C0##T; \
code = sqlite3_step(_handle); \
_CHECK(SQLITE_DONE, @"step1%s: multiple rows", #T); \
[self reset]; \
return val; \
} \


STEP1(Int);
STEP1(I64);
STEP1(F64);


- (Int)step:(BlockStepSql)block {
  int code = sqlite3_step(_handle);
  Int count = 0;
  while (code == SQLITE_ROW) {
    block(self);
    count++;
    code = sqlite3_step(_handle);
  }
  _CHECK(SQLITE_DONE, @"step:");
  [self reset];
  return count;
}


- (NSMutableArray*)map:(BlockMapSql)block {
  NSMutableArray* array = [NSMutableArray array];
  int code = sqlite3_step(_handle);
  while (code == SQLITE_ROW) {
    id el = block(self);
    [array addObject:el];
    code = sqlite3_step(_handle);
  }
  _CHECK(SQLITE_DONE, @"map:");
  [self reset];
  return array;
}


- (NSMutableArray*)filterMap:(BlockMapSql)block {
  NSMutableArray* array = [NSMutableArray array];
  int code = sqlite3_step(_handle);
  while (code == SQLITE_ROW) {
    id el = block(self);
    if (el) {
      [array addObject:el];
    }
    code = sqlite3_step(_handle);
  }
  _CHECK(SQLITE_DONE, @"map:");
  [self reset];
  return array;
}


- (void)bindIndex:(I32)index Int:(Int)value {
  int code;
  if (Int_is_64_bits) {
    code = sqlite3_bind_int64(_handle, index, value);
  }
  else {
    code = sqlite3_bind_int(_handle, index, value);
  }
  _ASSERT_OK(@"bind int: %d", index);
}


- (void)bindIndex:(I32)index I64:(I64)value {
  int code = sqlite3_bind_int64(_handle, index, value);
  _ASSERT_OK(@"bind I64: %d", index);
}


- (void)bindIndex:(I32)index U64:(U64)value {
  qk_check(value <= max_I64, @"U64 value exceeds max_I64; cannot store in sqlite: %llu", value);
  int code = sqlite3_bind_int64(_handle, index, value);
  _ASSERT_OK(@"bind I64: %d", index);
}


- (void)bindIndex:(I32)index F64:(F64)value {
  int code = sqlite3_bind_double(_handle, index, value);
  _ASSERT_OK(@"bind F64: %d", index);
}


- (void)bindIndex:(I32)index string:(NSString*)value {
  int code = sqlite3_bind_text(_handle, index, value.asUtf8, -1, SQLITE_TRANSIENT);
  _ASSERT_OK(@"bind string: %d; '%@'", index, value);
}


- (void)bindIndex:(I32)index data:(NSData*)value {
  NSUInteger l = value.length;
  qk_check(l < max_I32, @"data length exceeds max_I32; cannot store in sqlite: %p", value);
  int code = sqlite3_bind_blob(_handle, index, value.bytes, (int)value.length, SQLITE_TRANSIENT);
  _ASSERT_OK(@"bind data: %d; %@", index, value);
}


#define _ASSERT_VALID_INDEX \
qk_assert(index >= 0 && index < self.columnCount, @"bad index: %d; columnCount: %d", index, self.columnCount)

- (Int)getInt:(I32)index {
  _ASSERT_VALID_INDEX;
  if (Int_is_64_bits) {
    return sqlite3_column_int64(_handle, index);
  }
  else {
    return sqlite3_column_int(_handle, index);
  }
}


- (I64)getI64:(I32)index {
  _ASSERT_VALID_INDEX;
  return sqlite3_column_int64(_handle, index);
}


- (F64)getF64:(I32)index {
  _ASSERT_VALID_INDEX;
  return sqlite3_column_double(_handle, index);
}


- (NSString*)getString:(I32)index {
  _ASSERT_VALID_INDEX;
  return [NSString withUtf8:(Utf8)sqlite3_column_text(_handle, index)]; // might be faster to use _blob and _bytes instead of _text.
}


- (NSArray*)getStrings:(I32)count {
  qk_assert(count <= self.columnCount, @"bad count: %d; columnCount: %d", count, self.columnCount);
  return [NSArray mapIntTo:count block:^(Int i){
    return [self getString:(I32)i];
  }];
}


- (NSArray*)getStrings {
  return [NSArray mapIntTo:self.columnCount block:^(Int i){
    NSString* s = [self getString:(I32)i];
    return s ? s : @"<NULL>";
  }];
}


- (NSData*)getData:(I32)index {
  _ASSERT_VALID_INDEX;
  return [NSData dataWithBytes:sqlite3_column_blob(_handle, index) length:sqlite3_column_bytes(_handle, index)];
}

#define _COL(I, T, N) - (T) C##I##N { return [self get##N:I]; }
#define _COLP(I, T) _COL(I, T, T)
#define _COLS(I) _COLP(I, Int); _COLP(I, I64); _COLP(I, F64); _COL(I, NSString*, String); _COL(I, NSData*, Data)

_COLS(0);
_COLS(1);
_COLS(2);
_COLS(3);
_COLS(4);
_COLS(5);
_COLS(6);
_COLS(7);
_COLS(8);
_COLS(9);

#undef _COL
#undef _COLP
#undef _COLS



@end

