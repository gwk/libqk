// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "GLScene.h"


@interface QKGLLayer : CAOpenGLLayer

@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, weak, readonly) id<GLScene> scene;
@property (nonatomic) CGFloat maxContentScale;

DEC_INIT(Format:(QKPixFmt)format scene:(id<GLScene>)scene);

@end
