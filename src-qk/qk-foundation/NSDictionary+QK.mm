// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSDictionary+QK.h"


@implementation NSDictionary (QK)


- (BOOL)isMutable {
  return NO;
}


- (NSMutableDictionary*)addDictionary:(NSDictionary*)dictionary {
  NSMutableDictionary* d = self.mutableCopy;
  [d addEntriesFromDictionary:dictionary];
  return d;
}


@end
