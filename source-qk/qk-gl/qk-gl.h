// Copyright 2013 George King. All rights reserved.
// Permission to use this file is granted in libqk/license.txt.


#if TARGET_OS_IPHONE
# import <OpenGLES/ES2/gl.h>
#else // mac
# import <OpenGL/gl.h>
# import <OpenGL/glu.h>
#endif

#import "GLFragmentShader.h"
#import "GLObject.h"
#import "GLProgram.h"
#import "GLShader.h"
#import "GLVertexShader.h"
#import "qk-gl-util.h"