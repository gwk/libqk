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


- (Int)lastIndex {
  return self.count - 1;
}


#pragma mark - map


+ (NSMutableArray*)mapIntFrom:(Int)from to:(Int)to block:(BlockMapInt)block {
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


- (NSMutableArray*)map:(BlockMap)block {
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:self.count];
  for (id el in self) {
    id res = block(el);
    [a addObject:res];
  }
  return a;
}


- (NSMutableArray*)mapIndexed:(BlockMapObjInt)block {
  Int c = self.count;
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:c];
  for_in(i, c) {
    id el = [self objectAtIndex:i];
    id res = block(el, i);
    [a addObject:res];
  }
  return a;
}


- (NSMutableDictionary*)mapToDict:(BlockMapToPair)block {
  NSMutableDictionary* dict = [NSMutableDictionary new];
  for (id el in self) {
    Duo* d = block(el);
    [dict setItem:d];
  }
  return dict;
}


- (NSMutableArray*)filterMap:(BlockMap)block {
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:self.count];
  for (id el in self) {
    id res = block(el);
    if (res) {
      [a addObject:res];
    }
  }
  return a;
}


- (NSMutableDictionary*)filterMapToDict:(BlockMapToPair)block {
  NSMutableDictionary* dict = [NSMutableDictionary new];
  for (id el in self) {
    Duo* d = block(el);
   [dict setItemIgnoreNil:d];
  }
  return dict;
}


#pragma mark - reduce


- (id)reduce:(BlockReduce)block {
  id agg = nil;
  for (id el in self) {
    agg = block(agg, el);
  }
  return agg;
}


- (Int)reduceInt:(Int)initial block:(BlockReduceToInt)block {
  Int val = initial;
  for (id el in self) {
    val = block(val, el);
  }
  return val;
}


- (id)max:(BlockMap)block {
  id max = nil;
  id maxKey = nil;
  for (id el in self) {
    id key = block(el);
    if (!max || [maxKey compare:key] == NSOrderedAscending) {
      max = el;
      maxKey = key;
    }
  }
  return max;
}


- (F64)minF64:(BlockMapToF64)block {
  F64 min = INFINITY;
  for (id el in self) {
    F64 v = block(el);
    if (v < min) {
      min = v;
    }
  }
  return min;
}


- (F64)maxF64:(BlockMapToF64)block {
  F64 max = -INFINITY;
  for (id el in self) {
    F64 v = block(el);
    if (v > max) {
      max = v;
    }
  }
  return max;
}


- (F64)sum:(BlockMapToF64)block {
  F64 sum = 0;
  for (id el in self) {
    sum += block(el);
  }
  return sum;
}


- (NSArray*)sortedGroupedWithComparator:(NSComparator)comparator {
  NSArray* sorted = [self sortedArrayUsingComparator:comparator];
  NSMutableArray* g = [NSMutableArray new];
  id prev = nil;
  NSMutableArray* a = nil;
  for (id el in sorted) {
    NSComparisonResult r;
    if (prev) {
      r = comparator(prev, el);
    }
    else {
      r = NSOrderedAscending;
    }
    qk_assert(r == NSOrderedSame || r == NSOrderedAscending, @"comparator or sort failed: %@", sorted);
    if (r == NSOrderedAscending) {
      a = [NSMutableArray new];
      [g addObject:a];
    }
    [a addObject:el];
    prev = el;
  }
  return g;
}


- (BOOL)isMutable {
  return NO;
}


@end
