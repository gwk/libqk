// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#if TARGET_OS_IPHONE
# import <OpenGLES/ES2/gl.h>
#else
# import <OpenGL/gl3.h>
#endif


#import "GLScene.h"


@interface GLTestScene : NSObject <GLScene>
@end

