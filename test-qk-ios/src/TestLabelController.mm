// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "CRColor.h"
#import "UILabel+QK.h"
//#import "QKButton.h"
//#import "QKLabel.h"
#import "TestLabelController.h"


@interface TestLabelController ()
@end


@implementation TestLabelController


- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor l:.5];
#if 0
  CGFloat x = 4;
  CGFloat y = 4 + self.insetTop;

  QKLabel* ll = [QKLabel withFontSize:24 x:x y:uil.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexW];
  [self.view addSubview:ll];
  ll.text = @"QKLabel Left Top";
  ll.verticalAlign = QKVerticalAlignTop;
  
  QKLabel* lc = [QKLabel withFontSize:24 x:x y:ll.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexW];
  [self.view addSubview:lc];
  lc.text = @"QKLabel Center";
  lc.textAlignment = NSTextAlignmentCenter;
  lc.verticalAlign = QKVerticalAlignCenter;
  
  QKLabel* lr = [QKLabel withFontSize:24 x:x y:lc.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexW];
  [self.view addSubview:lr];
  lr.text = @"QKLabel Right Bottom";
  lr.textAlignment = NSTextAlignmentRight;
  lr.verticalAlign = QKVerticalAlignBottom;
  
  QKButton* button = [QKButton withFontSize:24 x:x y:lr.bottom + 4 w:w h:h min:1 max:1 flex:UIFlexW];
  [self.view addSubview:button];
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
#endif
}


@end

