// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"


@interface NSArray (QK)

- (id)el:(Int)index;
- (id)elOrNil:(Int)index;
- (id)elLast;
- (id)elLastOrNil;

#define EL(I) \
- (id)el##I; \
- (id)el##I##OrNil; \

EL(0);
EL(1);
EL(2);
EL(3);
EL(4);
EL(5);
EL(6);
EL(7);
EL(8);
EL(9);

- (Int)lastIndex;

#undef EL


+ (NSMutableArray*)mapIntFrom:(Int)from to:(Int)to block:(BlockMapInt)block;
+ (NSMutableArray*)mapIntTo:(Int)to block:(BlockMapInt)block;

- (NSMutableArray*)map:(BlockMap)block;
- (NSMutableArray*)mapIndexed:(BlockMapObjInt)block;
- (NSMutableDictionary*)mapToDict:(BlockMapToPair)block;

- (NSMutableArray*)filterMap:(BlockMap)block;
- (NSMutableDictionary*)filterMapToDict:(BlockMapToPair)block;

- (Int)reduceInt:(Int)initial block:(BlockReduceToInt)block;

- (id)max:(BlockMap)block;
- (F64)minF64:(BlockMapToF64)block;
- (F64)maxF64:(BlockMapToF64)block;
- (F64)sum:(BlockMapToF64)block;

- (NSArray*)sortedGroupedWithComparator:(NSComparator)comparator;

@end
