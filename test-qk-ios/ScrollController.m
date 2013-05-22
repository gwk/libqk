// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "UIColor+QK.h"
#import "UIView+QK.h"
#import "QKScrollView.h"
#import "ScrollController.h"


@interface ScrollController ()
@end


@implementation ScrollController

PROPERTY_SUBCLASS_ALIAS(QKScrollView, scrollView, ScrollView, self.view);


- (void)loadView {
  self.view = [QKScrollView withFlexFrame];
  self.view.backgroundColor = [UIColor r:1];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  CGSize s = self.view.bounds.size;
  s.width *= 2;
  s.height *= 2;
  self.scrollView.contentSize = s;
}


@end

