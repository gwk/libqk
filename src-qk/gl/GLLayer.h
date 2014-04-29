// Copyright 2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-vec.h"
#import "CCAGLLayer.h"
#import "QKPixFmt.h"
#import "GLEventHandler.h"

@protocol GLScene;

@interface GLLayer : CCAGLLayer


@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, weak, readonly) id<GLScene> scene;
@property (nonatomic, readonly) GLEventHandler* eventHandler;
@property (nonatomic) CGFloat maxContentsScale; // only useful for multiple screens of differing resolutions on mac.
@property (nonatomic, readonly) V2I32 drawableSize;
@property (nonatomic) int redisplayInterval;

DEC_INIT(Format:(QKPixFmt)format scene:(id<GLScene>)scene);

- (void)setupWithFormat:(QKPixFmt)format scene:(id<GLScene>)scene;

#if TARGET_OS_IPHONE

@property (nonatomic) BOOL asynchronous; // mac version is atomic.

- (void)enableContext;
- (void)disableContext;
- (void)enableRedisplayWithInterval:(int)interval duringTracking:(BOOL)duringTracking; // typically called at viewWillAppear
- (void)disableRedisplay; // typically called at viewWillDisappear
- (void)render; // render immediately; temporary? to avoid excessive rendering use enableRedisplay... and disableRedisplay.
#endif


// temporary
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGRect visibleRect;
@property (nonatomic) CGFloat zoomScale;

- (void)trackScrollBounds:(CGRect)scrollBounds contentSize:(CGSize)contentSize zoomScale:(CGFloat)zoomScale;

@end
