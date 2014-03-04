// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLLayer.h"


@protocol GLScene <NSObject>

- (void)setupGLLayer:(GLLayer*)layer time:(NSTimeInterval)time;
- (void)drawInGLLayer:(GLLayer*)layer time:(NSTimeInterval)time;

@end

