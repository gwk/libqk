// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CCAGLLayer.h"
#import "GLCanvasInfo.h"


@protocol GLScene <NSObject>

- (void)setupGLLayer:(CCAGLLayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info;
- (void)drawInGLLayer:(CCAGLLayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info;

@end

