// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSJSONSerialization+QK.h"
#import "NSBundle+QK.h"


@implementation NSBundle (QK)


+ (NSString*)resPath:(NSString*)resourceName ofType:(NSString*)type {
  auto path = [[self mainBundle] pathForResource:resourceName ofType:type];
  qk_assert(path, @"no resource named: %@; ext: %@", resourceName, type);
  return path;
}


+ (NSString*)resPath:(NSString*)resourceName {
  return [self resPath:resourceName ofType:nil];
}


+ (NSData*)dataNamed:(NSString*)resourceName {
  auto path = [self resPath:resourceName];
  NSError* e;
  NSData* d = [NSData dataWithContentsOfFile:path options:0 error:&e];
  qk_assert(!e, @"error reading data resource: %@", e);
  return d;
}


+ (id)jsonNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options {
  auto path = [self resPath:resourceName ofType:@"json"];
  NSError* e;
  id json = [NSJSONSerialization objectFromFilePath:path options:options error:&e];
  qk_assert(!e, @"error reading json resource: %@", e);
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

