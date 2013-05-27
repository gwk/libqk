// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-cg-util.h"
#import "UIColor+QK.h"
#import "UIView+QK.h"
#import "GLView.h"
#import "GLTestScene.h"
#import "ScrollController.h"


@interface ScrollController ()

@property (nonatomic) GLView* glView;
@property (nonatomic) id<GLScene> scene;

@end


@implementation ScrollController


PROPERTY_SUBCLASS_ALIAS(GLView, glView, GlView, self.view);


- (void)loadView {
    _scene = [GLTestScene new];
  self.glView = [GLView withFrame:CGRect256 format:QKPixFmtRGBAU8 scene:_scene];
  self.glView.eventHandler = [GLEventHandler new];
  self.glView.autoresizingMask = UIFlexSize;
  [self.glView setNeedsDisplay];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.glView enableRedisplayWithInterval:0 duringTracking:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
  [self.glView disableRedisplay];
}


@end

