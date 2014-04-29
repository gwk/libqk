// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


@interface NSDate (QK)

+ (NSTimeInterval)refTime;
+ (NSTimeInterval)posixTime;

+ (NSDate*)withRefTime:(NSTimeInterval)refTime;
+ (NSDate*)withPosixTime:(NSTimeInterval)posixTime;

- (NSTimeInterval)refInterval;
- (NSTimeInterval)posixInterval;

- (BOOL)isSameDayAs:(NSDate*)date;

@end

