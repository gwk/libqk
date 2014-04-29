// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSMutableData+QK.h"


@implementation NSMutableData (QK)


- (BOOL)isMutable {
  return YES;
}


+ (instancetype)withLength:(Int)length {
  return [[self alloc] initWithLength:length];
}


@end

