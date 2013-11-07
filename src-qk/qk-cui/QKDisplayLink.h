// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"


#if TARGET_OS_IPHONE
#define CCADisplayLink CADisplayLink
#else
#define CCADisplayLink NSTimer
#endif


@class QKDisplayLink;

typedef void (^BlockDisplayLink)(QKDisplayLink*);

@interface QKDisplayLink : NSObject

@property(nonatomic) BOOL paused;
//@property(nonatomic, readonly) CFTimeInterval timestamp; // timestamp for last frame displayed.
//@property(nonatomic, readonly) CFTimeInterval duration;
//@property(nonatomic) NSInteger frameInterval;

DEC_WITH(Tracking:(BOOL)tracking block:(BlockDisplayLink)block);

@end
