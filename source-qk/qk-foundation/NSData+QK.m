// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSArray+QK.h"
#import "NSData+QK.h"


NSString* const QKJsonErrorDomain = @"QKJsonErrorDomain";


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


+ (id)withPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr {
  assert(errorPtr, @"NULL error pointer");
  NSData* d = [self dataWithContentsOfURL:[NSURL fileURLWithPath:path]
                                  options:(map ? NSDataReadingMappedIfSafe : 0)
                                    error:errorPtr];
  if (*errorPtr) {
    return nil;
  }
  return d;
}


+ (id)withPath:(NSString*)path map:(BOOL)map {
  NSError* e = nil;
  NSData* d = [self withPath:path map:map error:&e];
  check(!e, @"withPath:map: failed; path: %@\n  map: %d\n  error: %@", path, map, e);
  return d;
}


+ (id)named:(NSString *)resourceName {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  return [self withPath:path map:NO];
}


- (id)objectOfType:(Class)class fromJsonWithError:(NSError **)errorPtr {
  assert(errorPtr, @"NULL error pointer");
  id result = [NSJSONSerialization JSONObjectWithData:self options:0 error:errorPtr];
  if (*errorPtr || !result) {
    return nil;
  }
  assert(result, @"nil result");
  if (![result isKindOfClass:class]) {
    NSString* desc = [NSString withFormat:@"JSON result type is not expected: %@; actual: %@", class, [result class]];
    *errorPtr =
    [NSError errorWithDomain:QKJsonErrorDomain
                        code:QKJsonErrorCodeUnexpectedRootType
                    userInfo:@{
  NSLocalizedDescriptionKey : desc,
     @"result" : result
     }];
    return nil;
  }
  return result;
}


- (id)dictFromJsonWithError:(NSError **)errorPtr {
  return [self objectOfType:[NSDictionary class] fromJsonWithError:errorPtr];
}


- (id)arrayFromJsonWithError:(NSError **)errorPtr {
  return [self objectOfType:[NSArray class] fromJsonWithError:errorPtr];
}



@end

