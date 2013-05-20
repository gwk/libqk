// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-vec.h"
#import "QKPixFmt.h"
#import "QKScrollView.h"
#import "GLScene.h"


@interface QKGLView : UIView <QKScrollTrackingDelegate>

@property (nonatomic, weak) id<GLScene> scene;
@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, readonly) V2I32 drawableSize;
@property (nonatomic) int redisplayInterval;

DEC_INIT(Frame:(CGRect)frame format:(QKPixFmt)format scene:(id<GLScene>)scene);

- (void)enableContext;
- (void)disableContext;

- (void)enableRedisplayWithInterval:(int)interval duringTracking:(BOOL)duringTracking; // typically called at viewWillAppear
- (void)disableRedisplay; // typically called at viewWillDisappear
- (void)render; // render immediately. to avoid excessive rendering use enableRedisplay... and disableRedisplay.

@end

