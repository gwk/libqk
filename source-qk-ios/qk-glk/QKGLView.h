// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKScrollView.h"
#import "GLScene.h"


@interface QKGLView : GLKView <QKScrollTrackingDelegate>

@property (nonatomic, weak) id<GLScene> scene;
@property (nonatomic, readonly) QKPixFmt format;

DEC_INIT(Frame:(CGRect)frame format:(QKPixFmt)format scene:(id<GLScene>)scene);

@end

