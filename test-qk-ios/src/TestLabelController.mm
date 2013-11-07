// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CUIColor.h"
#import "UILabel+QK.h"
#import "QKButton.h"
#import "QKLabel.h"
#import "TestLabelController.h"


@interface TestLabelController ()
@end


@implementation TestLabelController


- (UIView*)makeContentView {
  self.view.backgroundColor = [UIColor l:.5];
  UIView* v = [UIView withFlexFrame];
  CGFloat x = 4 + self.insetTop;
  CGFloat w = v.width - x * 2;
  CGFloat h = 60;

  UILabel* uil = [UILabel withFrame:CGRectMake(x, x, w, h) flex:UIFlexWidth];
  uil.font = [UIFont systemFontOfSize:24];
  uil.text = @"UILabel";
  [v addSubview:uil];
  
  QKLabel* ll = [QKLabel withFontSize:24 x:x y:uil.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexWidth];
  ll.text = @"QKLabel Left Top";
  ll.verticalAlign = QKVerticalAlignTop;
  [v addSubview:ll];
  
  QKLabel* lc = [QKLabel withFontSize:24 x:x y:ll.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexWidth];
  lc.text = @"QKLabel Center";
  lc.textAlignment = NSTextAlignmentCenter;
  lc.verticalAlign = QKVerticalAlignCenter;
  [v addSubview:lc];
  
  QKLabel* lr = [QKLabel withFontSize:24 x:x y:lc.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexWidth];
  lr.text = @"QKLabel Right Bottom";
  lr.textAlignment = NSTextAlignmentRight;
  lr.verticalAlign = QKVerticalAlignBottom;
  [v addSubview:lr];
  
  QKButton* button = [QKButton withFontSize:24 x:x y:lr.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexWidth];
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
  [v addSubview:button];

  return v;
}


@end

