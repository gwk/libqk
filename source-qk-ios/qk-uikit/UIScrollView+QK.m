// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIScrollView+QK.h"


@implementation UIScrollView (QK)


- (CGPoint)contentCenter {
  CGPoint o = self.contentOffset;
  CGSize s = self.bounds.size;
  return CGPointMake(roundf(o.x + s.width * .5), roundf(o.y + s.height * .5));
}


- (void)setContentCenter:(CGPoint)contentCenter {
  CGSize s = self.bounds.size;
  self.contentOffset = CGPointMake(contentCenter.x - s.width * .5, contentCenter.y - s.height * .5);
}


@end
