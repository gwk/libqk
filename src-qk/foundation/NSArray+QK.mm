// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSMutableDictionary+QK.h"
#import "NSArray+QK.h"


@implementation NSArray (QK)


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


- (id)elAtIndexPath:(NSIndexPath*)indexPath {
  id e = self;
  for_in(i, indexPath.length) {
    e = [e objectAtIndex:[indexPath indexAtPosition:i]];
  }
  return e;
}


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
    QKDuo* d = block(el);
    [dict setItem:d];
  }
  return dict;
}


- (NSMutableArray*)filter:(BlockFilter)block {
  NSMutableArray* a = [NSMutableArray new];
  for (id el in self) {
    BOOL res = block(el);
    if (res) {
      [a addObject:el];
    }
  }
  return a;
}


- (NSMutableArray*)filterMap:(BlockMap)block {
  NSMutableArray* a = [NSMutableArray new];
  for (id el in self) {
    id res = block(el);
    if (res) {
      [a addObject:res];
    }
  }
  return a;
}


- (NSMutableArray*)filterMapIndexed:(BlockMapObjInt)block {
  NSMutableArray* a = [NSMutableArray new];
  for_in(i, self.count) {
    id el = [self objectAtIndex:i];
    id res = block(el, i);
    if (res) {
      [a addObject:res];
    }
  }
  return a;
}


- (NSMutableDictionary*)filterMapToDict:(BlockMapToPair)block {
  NSMutableDictionary* dict = [NSMutableDictionary new];
  for (id el in self) {
    QKDuo* d = block(el);
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


- (F32)reduceF32:(F32)initial block:(BlockReduceToF32)block {
  F32 val = initial;
  for (id el in self) {
    val = block(val, el);
  }
  return val;
}


- (F64)reduceF64:(F64)initial block:(BlockReduceToF64)block {
  F64 val = initial;
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


- (NSMutableArray*)groupedWithComparator:(NSComparator)comparator {
  NSMutableArray* g = [NSMutableArray new];
  id prev = nil;
  NSMutableArray* a = nil;
  for (id el in self) {
    NSComparisonResult r;
    if (prev) {
      r = comparator(prev, el);
    }
    else {
      r = NSOrderedAscending;
    }
    if (r != NSOrderedSame) {
      a = [NSMutableArray new];
      [g addObject:a];
    }
    [a addObject:el];
    prev = el;
  }
  return g;
}


- (NSMutableArray*)sortedGroupedWithComparator:(NSComparator)comparator {
  // sort an array, and then group the elements that compare the same.
  NSArray* sorted = [self sortedArrayUsingComparator:comparator];
  return [sorted groupedWithComparator:comparator];
}


- (BOOL)isMutable {
  return NO;
}


- (NSArray*)subarrayTo:(Int)to {
    return [self subarrayWithRange:NSRangeMake(0, to)];
}


@end
