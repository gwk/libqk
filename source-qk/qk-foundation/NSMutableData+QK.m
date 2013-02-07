// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSMutableData+QK.h"


@implementation NSMutableData (QK)


- (BOOL)isMutable {
  return YES;
}


+ (id)withLength:(Int)length {
  return [[self alloc] initWithLength:length];
}


@end

