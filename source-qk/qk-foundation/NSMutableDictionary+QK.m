// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKDuo.h"
#import "NSMutableDictionary+QK.h"


@implementation NSMutableDictionary (QK)


- (void)setItem:(QKDuo*)item {
  [self setObject:item.b forKey:item.a];
}


- (void)setItemIgnoreNil:(QKDuo*)item {
  if (item.a && item.b) {
    [self setObject:item.b forKey:item.a];
  }
}


- (BOOL)isMutable {
  return YES;
}


@end
