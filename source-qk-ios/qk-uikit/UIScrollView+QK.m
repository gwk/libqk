// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIScrollView+QK.h"


@implementation UIScrollView (QK)


- (CGRect)contentFrame {
  return (CGRect) { CGPointZero, self.contentSize };
}


- (CGPoint)contentCenter {
  CGSize s = self.contentSize;
  return CGPointMake(s.width * .5, s.height * .5);
}


- (void)centerOnPoint:(CGPoint)point animated:(BOOL)animated {
  CGSize bs = self.bounds.size;
  CGPoint bh = CGPointMake(bs.width * .5, bs.height * .5); // size 'center' (unlike boundsCenter not offset by origin)
  CGSize cs = self.contentSize;
  
  CGPoint o = CGPointMake(clamp(point.x - bh.x, 0, MAX(0, cs.width - bs.width)),
                          clamp(point.y - bh.y, 0, MAX(0, cs.height - bs.height)));

  [self setContentOffset:o animated:animated];
}


- (void)centerOnPoint:(CGPoint)point {
  [self centerOnPoint:point animated:NO];
}


@end
