// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CUIView.h"
#import "CUIColor.h"
#import "QKButton.h"
#import "QKScrollView.h"
#import "TestScrollController.h"


@interface TestScrollController ()
@end


@implementation TestScrollController


PROPERTY_SUBCLASS_ALIAS(QKScrollView, scrollView, ScrollView, self.view);


#pragma mark - UIView


- (void)loadView {
  self.scrollView = [QKScrollView withFlexFrame];
  self.scrollView.delaysContentTouches = YES;
  self.scrollView.backgroundColor = [UIColor l:.5];
  CGFloat size = 768;
  UIView* cv = self.contentView = [UIView withFrame:CGRectMake(8, 8, size, size)];
  cv.backgroundColor = [UIColor l:.8];
  CGFloat step = 64;
  for_imns(i, step, size, step) {
    UIView* h = [UIView withFrame:CGRectMake(0, i, size, 2)];
    UIView* v = [UIView withFrame:CGRectMake(i, 0, 2, size)];
    h.backgroundColor = [UIColor l:.6];
    v.backgroundColor = [UIColor l:.6];
    [cv addSubview:h];
    [cv addSubview:v];
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
  [cv addSubview:button];
  [self.scrollView addSubview:cv];
  CGSize s = cv.size;
  s.width += 16;
  s.height += 16;
  self.scrollView.contentSize = s;
  LOG_RECT(self.insetFrame);
}


@end

