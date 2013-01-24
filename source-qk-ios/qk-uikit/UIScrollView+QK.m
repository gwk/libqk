// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIScrollView+QK.h"


@implementation UIScrollView (QK)


- (CGRect)contentBounds {
  return (CGRect) { CGPointZero, self.contentSize };
}


- (CGPoint)contentCenter {
  CGSize s = self.contentSize;
  return CGPointMake(s.width * .5, s.height * .5);
}


- (void)setContentOffsetClamped:(CGPoint)contentOffset animated:(BOOL)animated {
  CGSize bs = self.bounds.size;
  CGSize cs = self.contentSize;
  CGPoint o = CGPointMake(clamp(contentOffset.x, 0, cs.width - bs.width),
                          clamp(contentOffset.y, 0, cs.height - bs.height));
  [self setContentOffset:o animated:animated];
}


- (void)setContentOffsetClamped:(CGPoint)contentOffset {
  [self setContentOffsetClamped:contentOffset animated:NO];
}


- (void)centerOnPoint:(CGPoint)point animated:(BOOL)animated {
  CGSize bs = self.bounds.size;
  // bounds half: the 'center' of bounds.size; not offset by origin like boundsCenter
  CGPoint bh = CGPointMake(bs.width * .5, bs.height * .5);
  CGPoint o = CGPointMake(point.x - bh.x, point.y - bh.y);
  [self setContentOffsetClamped:o animated:animated];
}


- (void)centerOnPoint:(CGPoint)point {
  [self centerOnPoint:point animated:NO];
}


- (void)centerOnRect:(CGRect)rect animated:(BOOL)animated {
  CGSize bs = self.bounds.size;
  CGPoint o = CGPointMake(rect.origin.x - (bs.width - rect.size.width) * .5,
                          rect.origin.y - (bs.height - rect.size.height) * .5);
  [self setContentOffsetClamped:o animated:animated];
}


- (void)centerOnRect:(CGRect)rect {
  [self centerOnRect:rect animated:NO];
}


// center on the rect, and make the point within it visible.
// if rect does not contain point then ignore point (perhaps this could be improved).
- (void)centerOnRect:(CGRect)rect point:(CGPoint)point animated:(BOOL)animated {
  CGSize bs = self.bounds.size;
  CGRect cb = self.contentBounds;
  // offset for rectangle
  CGPoint o = CGPointMake(rect.origin.x - (bs.width - rect.size.width) * .5,
                          rect.origin.y - (bs.height - rect.size.height) * .5);
  if (CGRectContainsPoint(rect, point) &&
      CGRectContainsPoint(cb, point)) {
    // possible to accommodate point; move the rectangle to contain it.
    if (o.x > point.x) o.x = point.x;
    if (o.y > point.y) o.y = point.y;
    if (o.x < point.x - bs.width) o.x = point.x - bs.width;
    if (o.y < point.y - bs.height) o.y = point.y - bs.height;
  }
  [self setContentOffsetClamped:o animated:animated];
}


- (void)centerOnRect:(CGRect)rect point:(CGPoint)point {
  [self centerOnRect:rect point:point animated:NO];
}


@end
