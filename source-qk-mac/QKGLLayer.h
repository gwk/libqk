// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


@protocol QKGLRenderer;

@interface QKGLLayer : CAOpenGLLayer

@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, weak, readonly) id<QKGLRenderer> renderer;
@property (nonatomic) CGFloat maxContentScale;

- (id)initWithFormat:(QKPixFmt)format renderer:(id<QKGLRenderer>)renderer;

@end



@protocol QKGLRenderer

- (void)setupCGLContext:(CGLContextObj)ctx time:(NSTimeInterval)time;
- (void)drawInCGLContext:(CGLContextObj)ctx time:(NSTimeInterval)time size:(CGSize)size;

@end
