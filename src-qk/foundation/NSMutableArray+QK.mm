// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


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


@end

