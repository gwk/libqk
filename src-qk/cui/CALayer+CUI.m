// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "CALayer+CUI.h"


@implementation CALayer (CUI)


DEF_INIT(Frame:(CGRect)frame color:(CUIColor*)color) {
  INIT(self init);
  self.frame = frame;
  self.color = color;
  return self;
}


- (CUIColor*)color {
  return [CUIColor colorWithCGColor:self.backgroundColor];
}


- (void)setColor:(CUIColor*)color {
  self.backgroundColor = color.CGColor;
}


@end
