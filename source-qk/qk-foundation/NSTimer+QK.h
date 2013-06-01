// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


typedef void (^BlockTimer)(NSTimer*);

@interface NSTimer (QK)

- (void)dissolve;

- (F32)interpolation;

+ (NSTimer*)withInterval:(NSTimeInterval)interval
                tracking:(BOOL)tracking
                   block:(BlockTimer)block;

+ (NSTimer*)withInterval:(NSTimeInterval)interval
              expiration:(NSTimeInterval)expiration
                tracking:(BOOL)tracking
                   block:(BlockTimer)block
              completion:(BlockTimer)completion;

@end

