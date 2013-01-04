// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-functional.h"


@interface NSArray (QK)

+ (id)mapIntFrom:(int)from to:(int)to block:(BlockMapInt)block;
+ (id)mapIntTo:(int)to block:(BlockMapInt)block;

@end
