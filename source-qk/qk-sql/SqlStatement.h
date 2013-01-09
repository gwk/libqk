// Copyright George King 2013.
// Permission to use this file is granted in libqk/license.txt.


@class SqlDatabase;
@class SqlStatement;

// block types to perform an arbitrary actions on a statement as it steps through rows

typedef void (^BlockDoSql)(SqlStatement* statement);

typedef id (^BlockMapSql)(SqlStatement* statement);


@interface SqlStatement : NSObject

@property (nonatomic, readonly) SqlDatabase* db;
@property (nonatomic, readonly) NSString* query;

#define _COL(I, T, N) @property (nonatomic) T C##I##N
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


- (id)initWithDatabase:(SqlDatabase*)db string:(NSString*)string;

- (NSString*)string;
- (void)reset;
- (int)columnCount;
- (void)doBlock:(BlockDoSql)block;
- (NSArray*)map:(BlockMapSql)block;
- (void)bindInt:(Int)value index:(int)index;
- (void)bindF64:(F64)value index:(int)index;
- (void)bindString:(NSString*)value index:(int)index;
- (Int)getInt:(int)index;
- (Int)getI64:(int)index;
- (F64)getF64:(int)index;
- (NSString*)getString:(int)index;
- (NSArray*)getStrings:(int)count;

@end



