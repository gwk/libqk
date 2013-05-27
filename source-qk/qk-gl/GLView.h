// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-vec.h"
#import "QKPixFmt.h"
#import "GLScene.h"
#import "GLLayer.h"
#import "CUIView.h"


@interface GLView : CUIView

@property (nonatomic, readonly) GLLayer* glLayer;
@property (nonatomic) GLEventHandler* eventHandler;
@property (nonatomic, weak) id<GLScene> scene;
@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic) int redisplayInterval;

DEC_INIT(Frame:(CGRect)frame format:(QKPixFmt)format scene:(id<GLScene>)scene);

- (V2I32)drawableSize;
- (void)enableContext;
- (void)disableContext;
- (void)enableRedisplayWithInterval:(int)interval duringTracking:(BOOL)duringTracking; // typically called at viewWillAppear
- (void)disableRedisplay; // typically called at viewWillDisappear
- (void)render; // render immediately. to avoid excessive rendering use enableRedisplay... and disableRedisplay.

@end
