// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLScene.h"


@interface QKGLView : GLKView

@property (nonatomic, weak) id<GLScene> scene;
@property (nonatomic, readonly) QKPixFmt format;

- (id)initWithFrame:(CGRect)frame scene:(id<GLScene>)scene format:(QKPixFmt)glFormat;
+ (id)withFrame:(CGRect)frame scene:(id<GLScene>)scene format:(QKPixFmt)glFormat;

@end

