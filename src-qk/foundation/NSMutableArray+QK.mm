// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "NSArray+QK.h"
#import "NSMutableArray+QK.h"


@implementation NSMutableArray (QK)


- (id)pop {
  if (self.count) {
    id el = [self elLast];
    [self removeLastObject];
    return el;
  }
  return nil;
}


- (instancetype)reverse {
  NSInteger len = self.count;
  NSInteger last = len - 1;
  for_in(i, len / 2) {
    [self exchangeObjectAtIndex:i withObjectAtIndex:(last - i)];
  }
  return self;
}


- (void)insert:(id)el comparator:(NSComparator)comparator {
    // for now just do linear search.
    for_in(i, self.count) {
        NSComparisonResult r = comparator(el, self[i]);
        if (r == NSOrderedAscending) {
            [self insertObject:el atIndex:i];
            return;
        }
    }
    [self addObject:el];
}


@end

