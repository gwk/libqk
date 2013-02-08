// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-check.h"
#import "NSBundle+QK.h"


@implementation NSBundle (QK)


+ (NSString*)resPath:(NSString*)resourceName ofType:(NSString*)type {
  NSString* path = [[self mainBundle] pathForResource:resourceName ofType:type];
  assert(path, @"no resource named: %@", resourceName);
  return path;
}


+ (NSString*)resPath:(NSString*)resourceName {
  return [self resPath:resourceName ofType:nil];
}


@end

