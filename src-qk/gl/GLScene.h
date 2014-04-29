// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "GLLayer.h"


@protocol GLScene <NSObject>

- (void)setupGLLayer:(GLLayer*)layer time:(NSTimeInterval)time;
- (void)drawInGLLayer:(GLLayer*)layer time:(NSTimeInterval)time;

@end

