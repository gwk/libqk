// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLSceneInfo.h"


@protocol GLScene <NSObject>

- (void)setupGLLayer:(CALayer*)layer time:(NSTimeInterval)time info:(GLSceneInfo*)info;
- (void)drawInGLLayer:(CALayer*)layer time:(NSTimeInterval)time info:(GLSceneInfo*)info;

@end

