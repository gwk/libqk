// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSError+QK.h"


@implementation NSError (QK)


+ (NSError*)withDomain:(NSString*)domain code:(int)code desc:(NSString*)desc info:(NSDictionary*)info {
  NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:info];
  [d setObject:desc forKey:NSLocalizedDescriptionKey];
  return [self errorWithDomain:domain code:code userInfo:d];
}


+ (NSError*)withDesc:(NSString*)desc {
  return [self withDomain:@"GenericErrorDomain" code:0 desc:desc info:nil];
}


@end

