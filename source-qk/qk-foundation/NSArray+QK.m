// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSMutableDictionary+QK.h"
#import "NSArray+QK.h"


@implementation NSArray (Oro)


+ (id)mapIntFrom:(Int)from to:(Int)to block:(BlockMapInt)block {
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:(to - from)];
  for_imn(i, from, to) {
    id res = block(i);
    [a addObject:res];
  }
  return a;
}


+ (id)mapIntTo:(Int)to block:(BlockMapInt)block {
  return [self mapIntFrom:0 to:to block:block];
}


- (id)map:(BlockMap)block {
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:self.count];
  for (id el in self) {
    id res = block(el);
    [a addObject:res];
  }
  return a;
}


- (id)mapIndexed:(BlockMapObjInt)block {
  Int c = self.count;
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:c];
  for_in(i, c) {
    id el = [self objectAtIndex:i];
    id res = block(el, i);
    [a addObject:res];
  }
  return a;
}


- (id)mapToDict:(BlockMapToPair)block {
  NSMutableDictionary* dict = [NSMutableDictionary new];
  for (id el in self) {
    Duo* d = block(el);
    [dict setItem:d];
  }
  return dict;
}


@end
