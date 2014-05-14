// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-cr.h"


#if TARGET_OS_IPHONE
# define CRGLLayer CAEAGLLayer
#else
# define CRGLLayer CAOpenGLLayer
#endif


@interface CRGLLayer (CR)

@end
