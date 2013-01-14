// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"
#import "qk-sql-util.h"
#import "SqlDatabase.h"
#import "SqlStatement.h"


#define _CHECK(exp_code, fmt, ...) \
check(code == exp_code, @"%@\n%@\n" fmt, sql_failure_str(_db.handle, code), self.query, ##__VA_ARGS__)

#define _ASSERT(exp_code, fmt, ...) \
assert(code == exp_code, @"%@\n%@\n" fmt, sql_failure_str(_db.handle, code), self.query, ##__VA_ARGS__)

#define _CHECK_OK(...) _CHECK(SQLITE_OK, __VA_ARGS__)
#define _ASSERT_OK(...) _ASSERT(SQLITE_OK, __VA_ARGS__)


@interface SqlStatement ()

@property (nonatomic) sqlite3_stmt* handle;

@end


@implementation SqlStatement


- (void)dealloc {
  int code = sqlite3_finalize(_handle);
  _CHECK_OK(@"finalize");
}


- (id)initWithDatabase:(SqlDatabase*)db query:(NSString*)query {
  INIT(super init);
  _db = db;
  Utf8 tail = NULL;
  int code = sqlite3_prepare_v2(_db.handle, query.asUtf8, -1, &_handle, &tail);
  _CHECK_OK(@"prepare: %@", query);
  assert(!*tail, @"prepared query has unused tail: '%s'", tail);
  return self;
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


- (void)step1:(BlockStepSql)block {
  int code = sqlite3_step(_handle);
  _CHECK(SQLITE_ROW, @"step1: no rows");
  block(self);
  sqlite3_step(_handle);
  _CHECK(SQLITE_DONE, @"step1: multiple rows");
  [self reset];
}


- (Int)step1Int {
  int code = sqlite3_step(_handle);
  _CHECK(SQLITE_ROW, @"step1Int: no rows");
  Int val = self.C0Int;
  code = sqlite3_step(_handle);
  _CHECK(SQLITE_DONE, @"step1Int: multiple rows");
  [self reset];
  return val;
}


- (I64)step1I64 {
  int code = sqlite3_step(_handle);
  _CHECK(SQLITE_ROW, @"step1Int: no rows");
  I64 val = self.C0I64;
  sqlite3_step(_handle);
  _CHECK(SQLITE_DONE, @"step1Int: multiple rows");
  [self reset];
  return val;
}


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


- (NSArray*)map:(BlockMapSql)block {
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


- (NSArray*)filterMap:(BlockMapSql)block {
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


- (void)bindIndex:(int)index Int:(Int)value {
  int code;
  if (Int_is_64_bits) {
    code = sqlite3_bind_int64(_handle, index, value);
  }
  else {
    code = sqlite3_bind_int(_handle, index, value);
  }
  _ASSERT_OK(@"bind int: %d", index);
}


- (void)bindIndex:(int)index I64:(I64)value {
  int code = sqlite3_bind_int(_handle, index, value);
  _ASSERT_OK(@"bind I64: %d", index);  
}


- (void)bindIndex:(int)index F64:(F64)value {
  int code = sqlite3_bind_double(_handle, index, value);
  _ASSERT_OK(@"bind F64: %d", index);
}


- (void)bindIndex:(int)index string:(NSString*)value {
  int code = sqlite3_bind_text(_handle, index, value.asUtf8, -1, SQLITE_TRANSIENT);
  _ASSERT_OK(@"bind string: %d; '%@'", index, value);
}


#define _ASSERT_VALID_INDEX \
assert(index >= 0 && index < self.columnCount, @"bad index: %d; columnCount: %d", index, self.columnCount)

- (Int)getInt:(int)index {
  _ASSERT_VALID_INDEX;
  if (Int_is_64_bits) {
    return sqlite3_column_int64(_handle, index);
  }
  else {
    return sqlite3_column_int(_handle, index);
  }
}


- (Int)getI64:(int)index {
  _ASSERT_VALID_INDEX;
   return sqlite3_column_int64(_handle, index);
}


- (F64)getF64:(int)index {
  _ASSERT_VALID_INDEX;
  return sqlite3_column_double(_handle, index);
}


- (NSString*)getString:(int)index {
  _ASSERT_VALID_INDEX;
  return [NSString withUtf8:(Utf8)sqlite3_column_text(_handle, index)];
}


- (NSArray*)getStrings:(int)count {
  assert(count <= self.columnCount, @"bad count: %d; columnCount: %d", count, self.columnCount);
  return [NSArray mapIntTo:count block:^(Int i){
    return [self getString:i];
  }];
}


- (NSArray*)getStrings {
  return [NSArray mapIntTo:self.columnCount block:^(Int i){
    NSString* s = [self getString:i];
    return s ? s : @"<NULL>";
  }];
}


#define _COL(I, T, N) - (T) C##I##N { return [self get##N:I]; }
#define _COLP(I, T) _COL(I, T, T)
#define _COLS(I) _COLP(I, Int); _COLP(I, I64); _COLP(I, F64); _COL(I, NSString*, String);

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

