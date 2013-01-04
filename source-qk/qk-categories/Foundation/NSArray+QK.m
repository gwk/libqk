// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSArray+QK.h"


@implementation NSArray (Oro)


+ (id)mapIntFrom:(int)from to:(int)to block:(BlockMapInt)block {
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:(to - from)];
  for_imn(i, from, to) {
    id e = block(i);
    [a addObject:e];
  }
  return a;
}


+ (id)mapIntTo:(int)to block:(BlockMapInt)block {
  return [self mapIntFrom:0 to:to block:block];
}


@end
