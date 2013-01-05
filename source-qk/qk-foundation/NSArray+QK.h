// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"


@interface NSArray (QK)

+ (id)mapIntFrom:(Int)from to:(Int)to block:(BlockMapInt)block;
+ (id)mapIntTo:(Int)to block:(BlockMapInt)block;

- (id)map:(BlockMap)block;
- (id)mapIndexed:(BlockMapObjInt)block;

- (id)mapToDict:(BlockMapToPair)block;

@end
