// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSArray+QK.h"
#import "NSBundle+QK.h"
#import "NSError+QK.h"
#import "QKErrorDomain.h"
#import "NSData+QK.h"


@implementation NSData (QK)


+ (instancetype)join:(NSArray*)array {
  Int length = [array reduceInt:0 block:^(Int v, NSData* el){
    return (Int)(v + el.length);
  }];
  NSMutableData* d = [NSMutableData dataWithCapacity:length];
  for (NSData* el in array) {
    [d appendBytes:el.bytes length:el.length];
  }
  return d;
}


+ (instancetype)withPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr {
  // give application code the option of handling error.
  if (!errorPtr) {
    NSError* e = nil;
    id res = [self withPath:path map:map error:&e];
    qk_check(!e, @"NSData withPath: %@; map: %d; error: %@", path, map, e);
    return res;
  }
  
  NSData* d = [self dataWithContentsOfURL:[NSURL fileURLWithPath:path]
                                  options:(map ? NSDataReadingMappedIfSafe : 0)
                                    error:errorPtr];
  if (*errorPtr) {
    return nil;
  }
  return d;
}


+ (instancetype)withPath:(NSString*)path map:(BOOL)map {
  NSError* e = nil;
  NSData* d = [self withPath:path map:map error:&e];
  qk_check(!e, @"withPath:map: failed; path: %@\n  map: %d\n  error: %@", path, map, e);
  return d;
}


+ (instancetype)named:(NSString *)resourceName {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  return [self withPath:path map:NO];
}


- (id)objectOfType:(Class)class_ fromJsonWithError:(NSError **)errorPtr {
  qk_assert(errorPtr, @"NULL error pointer");
  id result = [NSJSONSerialization JSONObjectWithData:self options:0 error:errorPtr];
  if (*errorPtr || !result) {
    return nil;
  }
  qk_assert(result, @"nil result");
  CHECK_SET_ERROR_RET_NIL([result isKindOfClass:class_], QK, JsonUnexpectedRootType, @"unexpected JSON result type", @{
                          @"expected-type" : class_,
                          @"actual-type" : [result class],
                          @"result" : result
                          });
  return result;
}


- (id)dictFromJsonWithError:(NSError **)errorPtr {
  return [self objectOfType:[NSDictionary class] fromJsonWithError:errorPtr];
}


- (id)arrayFromJsonWithError:(NSError **)errorPtr {
  return [self objectOfType:[NSArray class] fromJsonWithError:errorPtr];
}


- (BOOL)isMutable {
  return NO;
}


@end

