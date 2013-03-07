// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLCanvasInfo.h"


@protocol GLScene <NSObject>

- (void)setupGLLayer:(CALayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info;
- (void)drawInGLLayer:(CALayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info;

@end

