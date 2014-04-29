// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-types.h"


typedef void (^BlockTimer)(NSTimer*);

@interface NSTimer (QK)

- (void)dissolve;

- (F32)lerpFactor;
- (F32)lerpFactorEaseInOut;

+ (NSTimer*)withInterval:(NSTimeInterval)interval
                tracking:(BOOL)tracking
                   block:(BlockTimer)block;

+ (NSTimer*)withDelay:(NSTimeInterval)delay
             tracking:(BOOL)tracking
                block:(BlockTimer)block;

+ (NSTimer*)withInterval:(NSTimeInterval)interval
              expiration:(NSTimeInterval)expiration
                tracking:(BOOL)tracking
                   block:(BlockTimer)block
              completion:(BlockTimer)completion;

@end

