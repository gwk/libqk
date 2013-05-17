// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-check.h"
#import "NSJSONSerialization+QK.h"
#import "NSBundle+QK.h"


@implementation NSBundle (QK)


+ (NSString*)resPath:(NSString*)resourceName ofType:(NSString*)type {
  NSString* path = [[self mainBundle] pathForResource:resourceName ofType:type];
  qk_assert(path, @"no resource named: %@", resourceName);
  return path;
}


+ (NSString*)resPath:(NSString*)resourceName {
  return [self resPath:resourceName ofType:nil];
}


+ (id)jsonNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options {
  NSString* path = [self resPath:resourceName ofType:@"json"];
  NSError* error = nil;
  id json = [NSJSONSerialization JSONObjectFromFilePath:path options:options error:&error];
  qk_assert(!error, @"error reading json resource: %@", error);
  return json;
}

@end

