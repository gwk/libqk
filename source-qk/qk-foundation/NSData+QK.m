// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSArray+QK.h"
#import "NSData+QK.h"


@implementation NSData (QK)


+ (id)join:(NSArray*)array {
  Int length = [array reduceInt:0 block:^(Int v, NSData* el){
    return (Int)(v + el.length);
  }];
  NSMutableData* d = [NSMutableData dataWithCapacity:length];
  for (NSData* el in array) {
    [d appendBytes:el.bytes length:el.length];
  }
  return d;
}


@end

