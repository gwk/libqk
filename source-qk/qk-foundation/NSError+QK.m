// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSError+QK.h"


@implementation NSError (QK)


+ (NSError*)withDomain:(NSString*)domain code:(int)code desc:(NSString*)desc info:(NSDictionary*)info {
  NSMutableDictionary* d = info.mutableCopy;
  [d setObject:desc forKey:NSLocalizedDescriptionKey];
  return [self errorWithDomain:domain code:code userInfo:d];
}


@end

