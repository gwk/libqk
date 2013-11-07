// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CALayer+CUI.h"


@implementation CALayer (CUI)


- (CUIColor*)backgroundUIColor {
  return [CUIColor colorWithCGColor:self.backgroundColor];
}


- (void)setBackgroundUIColor:(CUIColor*)color {
  self.backgroundColor = color.CGColor;
}


@end
