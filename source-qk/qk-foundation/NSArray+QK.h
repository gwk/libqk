// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"


@interface NSArray (QK)

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

#undef EL


+ (id)mapIntFrom:(Int)from to:(Int)to block:(BlockMapInt)block;
+ (id)mapIntTo:(Int)to block:(BlockMapInt)block;

- (id)map:(BlockMap)block;
- (id)mapIndexed:(BlockMapObjInt)block;
- (id)mapToDict:(BlockMapToPair)block;


- (int)reduceInt:(Int)initial block:(BlockReduceToInt)block;

@end