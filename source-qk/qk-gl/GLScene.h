// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#if TARGET_OS_IPHONE
typedef EAGLContext* QKGLContext;
#else
typedef CGLContextObj QKGLContext;
#endif

@protocol GLScene <NSObject>

- (void)setupGLContext:(QKGLContext)ctx time:(NSTimeInterval)time size:(CGSize)size scale:(CGFloat)scale;
- (void)drawInGLContext:(QKGLContext)ctx time:(NSTimeInterval)time size:(CGSize)size scale:(CGFloat)scale;

@end

