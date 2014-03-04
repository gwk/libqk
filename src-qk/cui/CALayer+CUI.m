// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "CALayer+CUI.h"


@implementation CALayer (CUI)


- (CUIColor*)backgroundCUIColor {
  return [CUIColor colorWithCGColor:self.backgroundColor];
}


- (void)setBackgroundCUIColor:(CUIColor*)color {
  self.backgroundColor = color.CGColor;
}


@end
