// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSJSONSerialization+QK.h"
#import "NSBundle+QK.h"


@implementation NSBundle (QK)


+ (NSString*)resPath:(NSString*)resourceName ofType:(NSString*)type {
  NSString* path = [[self mainBundle] pathForResource:resourceName ofType:type];
  qk_assert(path, @"no resource named: %@; ext: %@", resourceName, type);
  return path;
}


+ (NSString*)resPath:(NSString*)resourceName {
  return [self resPath:resourceName ofType:nil];
}


+ (id)jsonNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options {
  NSString* path = [self resPath:resourceName ofType:@"json"];
  NSError* error = nil;
  id json = [NSJSONSerialization objectFromFilePath:path options:options error:&error];
  qk_assert(!error, @"error reading json resource: %@", error);
  return json;
}


+ (NSDictionary*)dictNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options {
  NSDictionary* d = [self jsonNamed:resourceName options:options];
  ASSERT_KIND(d, NSDictionary);
  return d;
}


+ (NSArray*)arrayNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options {
  NSArray* a = [self jsonNamed:resourceName options:options];
  ASSERT_KIND(a, NSArray);
  return a;
}



@end

