// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSJSONSerialization+QK.h"


@implementation NSJSONSerialization (QK)

+ (id)JSONObjectFromFilePath:(NSString*)path options:(NSJSONReadingOptions)options error:(NSError**)error {
  NSInputStream* stream = [NSInputStream inputStreamWithFileAtPath:path];
  [stream open];
  id res =  [self JSONObjectWithStream:stream options:options error:error];
  [stream close];
  return res;
}

@end

