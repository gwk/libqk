// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSAttributedString+QK.h"
#import "CRColor.h"
#import "QKRichLabel.h"
#import "TestRichLabelController.h"

#define lorem_ipsum @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"

@interface TestRichLabelController ()
@end


@implementation TestRichLabelController


- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor l:.5];
  CGFloat x = 4;
  CGFloat y = 4 + self.insetTop;
  CGFloat w = self.view.w - x * 2;
  CGFloat h = 60;
  
  auto l = [QKRichLabel withFrame:CGRectMake(x, y, w, h) flex:UIFlexW];
  [self.view addSubview:l];
  l.backgroundColor = [CRColor w];
  l.richText = [NSAttributedString withString:nil
                                         attrs:strAttrs([CRFont boldSystemFontOfSize:24],
                                                        [CRColor k],
                                                        NSTextAlignmentCenter)];
  l.vertAlignment = QKVertAlignmentCenter;
}


@end

