// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSMutableDictionary+QK.h"


@implementation NSMutableDictionary (QK)


- (void)setItem:(Duo*)item {
  [self setObject:item.b forKey:item.a];
}


@end
