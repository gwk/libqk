// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import <QuartzCore/QuartzCore.h>


#if TARGET_OS_IPHONE
# define CCAGLLayer CAEAGLLayer
#else
# define CCAGLLayer CAOpenGLLayer
#endif


@interface CCAGLLayer (CCA)

@end
