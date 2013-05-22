// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "UIColor+QK.h"
#import "UIView+QK.h"
#import "QKScrollView.h"
#import "QKGLView.h"
#import "GLTestScene.h"
#import "ScrollController.h"


@interface ScrollController ()

@property (nonatomic) QKGLView* glView;
@property (nonatomic) id<GLScene> scene;

@end


@implementation ScrollController

PROPERTY_SUBCLASS_ALIAS(QKScrollView, scrollView, ScrollView, self.view);


- (void)loadView {
  self.view = [QKScrollView withFlexFrame];
  self.view.backgroundColor = [UIColor r:.5];
  _scene = [GLTestScene new];
  _glView = [QKGLView withFrame:self.view.bounds format:QKPixFmtRGBAU8 scene:_scene];
  _glView.autoresizingMask = UIFlexSize;
  [self.view addSubview:_glView];
  [_glView setNeedsDisplay];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  CGSize s = self.view.bounds.size;
  s.width *= 2;
  s.height *= 2;
  self.scrollView.contentSize = s;
  [self.view inspect:@"appear"];
  [_glView enableRedisplayWithInterval:0 duringTracking:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
  [_glView disableRedisplay];
}


@end

