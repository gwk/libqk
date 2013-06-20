// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CUIView.h"
#import "UIColor+QK.h"
#import "QKButton.h"
#import "QKUIScrollView.h"
#import "TestUIScrollController.h"


@interface TestUIScrollController ()
@end


@implementation TestUIScrollController


PROPERTY_SUBCLASS_ALIAS(QKUIScrollView, scrollView, ScrollView, self.view);


#pragma mark - UIView


- (void)loadView {
  self.scrollView = [QKUIScrollView withFlexFrame];
  self.scrollView.delaysContentTouches = YES;
  self.scrollView.backgroundColor = [UIColor l:.5];
  CGFloat size = 512;
  UIView* contentView = [UIView withFrame:CGRectMake(8, 8, size, size)];
  contentView.backgroundColor = [UIColor l:.8];
  CGFloat step = 64;
  for_imns(i, step, size, step) {
    UIView* h = [UIView withFrame:CGRectMake(0, i, size, 2)];
    UIView* v = [UIView withFrame:CGRectMake(i, 0, 2, size)];
    h.backgroundColor = [UIColor l:.5];
    v.backgroundColor = [UIColor l:.5];
    [contentView addSubview:h];
    [contentView addSubview:v];
  }
  
  QKButton* button = [QKButton withFrame:CGRectMake(32, 32, 96, 64)];
  button.text = @"Button";
  button.blockTouchDown = ^{
    errL(@"touch down");
  };
  button.blockTouchUp = ^{
    errL(@"touch up");
  };
  button.blockTouchCancelled = ^{
    errL(@"touch cancelled");
  };
  [contentView addSubview:button];
  [self.scrollView addSubview:contentView];
  CGSize s = contentView.size;
  s.width += 16;
  s.height += 16;
  self.scrollView.contentSize = s;
}


@end

