// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


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

- (id)elAtIndexPath:(NSIndexPath*)indexPath;

- (Int)lastIndex;

#undef EL


+ (NSMutableArray*)mapIntFrom:(Int)from to:(Int)to block:(BlockMapInt)block;
+ (NSMutableArray*)mapIntTo:(Int)to block:(BlockMapInt)block;

- (NSMutableArray*)map:(BlockMap)block;
- (NSMutableArray*)mapIndexed:(BlockMapObjInt)block;
- (NSMutableDictionary*)mapToDict:(BlockMapToPair)block;

- (NSMutableArray*)filter:(BlockFilter)block;
- (NSMutableArray*)filterMap:(BlockMap)block;
- (NSMutableArray*)filterMapIndexed:(BlockMapObjInt)block;
- (NSMutableDictionary*)filterMapToDict:(BlockMapToPair)block;

- (Int)reduceInt:(Int)initial block:(BlockReduceToInt)block;
- (F32)reduceF32:(F32)initial block:(BlockReduceToF32)block;
- (F64)reduceF64:(F64)initial block:(BlockReduceToF64)block;

- (id)max:(BlockMap)block;
- (F64)minF64:(BlockMapToF64)block;
- (F64)maxF64:(BlockMapToF64)block;
- (F64)sum:(BlockMapToF64)block;

- (NSMutableArray*)groupedWithComparator:(NSComparator)comparator;
- (NSMutableArray*)sortedGroupedWithComparator:(NSComparator)comparator;

- (NSArray*)subarrayTo:(Int)to;

@end
