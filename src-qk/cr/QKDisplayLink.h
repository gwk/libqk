// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-macros.h"

@class QKDisplayLink;

typedef void (^BlockDisplayLink)(QKDisplayLink*);

@interface QKDisplayLink : NSObject

@property(nonatomic) BOOL paused;
//@property(nonatomic, readonly) CFTimeInterval timestamp; // timestamp for last frame displayed.
//@property(nonatomic, readonly) CFTimeInterval duration;
//@property(nonatomic) NSInteger frameInterval;

DEC_WITH(Tracking:(BOOL)tracking block:(BlockDisplayLink)block);

@end
