// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSOutputStream+QK.h"


@implementation NSOutputStream (QK)


- (Int)writeData:(id<QKData>)data {
  return [self write:(U8*)data.bytes maxLength:data.length];
}


@end

