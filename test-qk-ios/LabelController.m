// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIColor+QK.h"
#import "UILabel+QK.h"
#import "QKLabel.h"
#import "LabelController.h"


@interface LabelController ()
@end


@implementation LabelController


- (void)loadView {
  
  self.view = [UIView withFlexFrame];
  self.view.backgroundColor = [UIColor l:.5];
  CGFloat x = 4;
  CGFloat w = self.view.width - x * 2;

  UILabel* uil = [UILabel withFontSize:24 lines:1 x:x y:x w:w h:0 flex:UIFlexWidth];
  uil.text = @"UILabel";
  [self.view addSubview:uil];
  
  QKLabel* ll = [QKLabel withFontSize:24 lines:1 x:x y:uil.bottom + 4 w:w h:60 flex:UIFlexWidth];
  ll.text = @"QKLabel Left Top";
  ll.verticalAlign = QKVerticalAlignTop;
  [self.view addSubview:ll];
  
  QKLabel* lc = [QKLabel withFontSize:24 lines:1 x:x y:ll.bottom + 4 w:w h:60 flex:UIFlexWidth];
  lc.text = @"QKLabel Center";
  lc.textAlignment = NSTextAlignmentCenter;
  lc.verticalAlign = QKVerticalAlignCenter;
  [self.view addSubview:lc];
  
  QKLabel* lr = [QKLabel withFontSize:24 lines:1 x:x y:lc.bottom + 4 w:w h:60 flex:UIFlexWidth];
  lr.text = @"QKLabel Right Bottom";
  lr.textAlignment = NSTextAlignmentRight;
  lr.verticalAlign = QKVerticalAlignBottom;
  [self.view addSubview:lr];

  [self.view inspect];
}


@end

