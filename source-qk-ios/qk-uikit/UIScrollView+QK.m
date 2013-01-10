// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIScrollView+QK.h"


@implementation UIScrollView (QK)


- (CGPoint)contentCenter {
  CGSize s = self.contentSize;
  return CGPointMake(s.width * .5, s.height * .5);
}


- (void)centerOn:(CGPoint)point {
  CGSize s = self.bounds.size;
  CGPoint o = CGPointMake(point.x - s.width * .5, point.y - s.height * .5);
  // TODO: keep in bounds!
  self.contentOffset = o;
}




@end
