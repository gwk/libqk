// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


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

@end

