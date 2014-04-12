// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-vec.h"


@class SqlDatabase;
@class SqlStatement;

// block types to perform an arbitrary actions on a statement as it steps through rows
typedef void (^BlockStepSql)(SqlStatement* statement);
typedef id (^BlockMapSql)(SqlStatement* statement);

@interface SqlStatement : NSObject

@property (nonatomic, readonly) SqlDatabase* db;
@property (nonatomic, readonly) NSString* query;
@property (nonatomic, readonly) sqlite3_stmt* handle;

#define _COL(I, T, N) @property (nonatomic) T C##I##N
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

DEC_INIT(Database:(SqlDatabase*)db query:(NSString*)query);

- (void)reset;
- (int)columnCount;
- (void)execute;
- (BOOL)step;
- (Int)step1Int;
- (I64)step1I64;
- (F64)step1F64;
- (Int)step:(BlockStepSql)block;
- (NSMutableArray*)map:(BlockMapSql)block;
- (NSMutableArray*)filterMap:(BlockMapSql)block;
- (void)bindIndex:(I32)index Int:(Int)value;
- (void)bindIndex:(I32)index I64:(I64)value;
- (void)bindIndex:(I32)index U64:(U64)value;
- (void)bindIndex:(I32)index F64:(F64)value;
- (void)bindIndex:(I32)index string:(NSString*)value;
- (void)bindIndex:(I32)index data:(NSData*)value;
- (Int)getInt:(I32)index;
- (I64)getI64:(I32)index;
- (F64)getF64:(I32)index;
- (NSString*)getString:(I32)index;
- (NSArray*)getStrings:(I32)count;
- (NSArray*)getStrings;

@end



