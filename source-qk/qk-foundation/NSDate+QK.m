// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSDate+QK.h"


@implementation NSDate (QK)


+ (NSTimeInterval)refTime {
  return [self timeIntervalSinceReferenceDate];
}


+ (NSTimeInterval)posixTime {
  static NSTimeInterval offset = 0;
  if (!offset) {
    NSDate* ref = [self dateWithTimeIntervalSinceReferenceDate:0];
    offset = [ref timeIntervalSince1970];
  }
  return [self timeIntervalSinceReferenceDate] + offset;
}


+ (NSDate*)withRefTime:(NSTimeInterval)refTime {
  return [self dateWithTimeIntervalSinceReferenceDate:refTime];
}


+ (NSDate*)withPosixTime:(NSTimeInterval)posixTime {
  return [self dateWithTimeIntervalSince1970:posixTime];
}


@end

