// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface NSDate (QK)

+ (NSTimeInterval)refTime;
+ (NSTimeInterval)posixTime;

+ (NSDate*)withRefTime:(NSTimeInterval)refTime;
+ (NSDate*)withPosixTime:(NSTimeInterval)posixTime;

- (NSTimeInterval)refInterval;
- (NSTimeInterval)posixInterval;

@end

