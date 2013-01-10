// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSMutableDictionary+QK.h"
#import "NSArray+QK.h"


@implementation NSArray (Oro)


- (id)el:(Int)index {
  return [self objectAtIndex:index];
}

- (id)elOrNil:(Int)index {
  return (index < self.count) ? [self objectAtIndex:index] : nil;
}


- (id)elLast {
  return [self lastObject];
}


- (id)elLastOrNil {
  Int c = self.count;
  return c > 0 ? [self objectAtIndex:c - 1] : nil;
}


#define EL(I) \
- (id)el##I { return [self objectAtIndex:I]; } \
- (id)el##I##OrNil { return (I < self.count) ? [self objectAtIndex:I] : nil; } \

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


#pragma mark - map


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


#pragma mark - reduce


- (int)reduceInt:(Int)initial block:(BlockReduceToInt)block {
  Int val = initial;
  for (id el in self) {
    val = block(val, el);
  }
  return val;
}


@end
