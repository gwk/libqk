// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


// UIScrollView can be rather confusing to use once zooming is enabled.
// essentially, the bounds and content rect have the zoomScale applied to them,
// which makes working with the coordinates dependent on the current zoomScale.
// contentOffset is always equal to self.bounds.origin.

// to deal with this, we define helper methods for the 'zoom' coordinate system,
// which is the self system divided by the zoom scale.



#import "qk-macros.h"
#import "qk-cg-util.h"
#import "qk-log.h"
#import "NSUIView.h"
#import "UIView+QK.h"
#import "UIScrollView+QK.h"


@implementation UIScrollView (QK)


// rect for contents.
- (CGRect)contentBounds {
  return (CGRect) { CGPointZero, self.contentSize };
}


- (CGPoint)contentCenter {
  CGSize s = self.contentSize;
  return CGPointMake(s.width * .5, s.height * .5);
}


- (void)setContentOffsetClamped:(CGPoint)contentOffset animated:(BOOL)animated {
  CGSize bs = self.boundsSize;
  CGSize cs = self.contentSize;
  CGPoint o = CGPointMake(CLAMP(contentOffset.x, 0, cs.width - bs.width),
                          CLAMP(contentOffset.y, 0, cs.height - bs.height));
  [self setContentOffset:o animated:animated];
}


- (void)setContentOffsetClamped:(CGPoint)contentOffset {
  [self setContentOffsetClamped:contentOffset animated:NO];
}


#pragma mark centerOnContent


- (void)centerOnContentPoint:(CGPoint)point animated:(BOOL)animated {
  CGSize bs = self.boundsSize;
  // bounds half: the 'center' of bounds.size; not offset by origin like boundsCenter
  CGPoint bh = CGPointMake(bs.width * .5, bs.height * .5);
  CGPoint o = CGPointMake(point.x - bh.x, point.y - bh.y);
  [self setContentOffsetClamped:o animated:animated];
}


- (void)centerOnContentPoint:(CGPoint)point {
  [self centerOnContentPoint:point animated:NO];
}


- (void)centerOnContentRect:(CGRect)rect animated:(BOOL)animated {
  CGSize bs = self.boundsSize;
  CGPoint o = CGPointMake(rect.origin.x - (bs.width - rect.size.width) * .5,
                          rect.origin.y - (bs.height - rect.size.height) * .5);
  [self setContentOffsetClamped:o animated:animated];
}


- (void)centerOnContentRect:(CGRect)rect {
  [self centerOnContentRect:rect animated:NO];
}


// center on the rect, and make the point within it visible.
// if rect does not contain point then ignore point (perhaps this could be improved).
- (void)centerOnContentRect:(CGRect)rect point:(CGPoint)point animated:(BOOL)animated {
  CGSize bs = self.boundsSize;
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


- (void)centerOnContentRect:(CGRect)rect point:(CGPoint)point {
  [self centerOnContentRect:rect point:point animated:NO];
}


#pragma mark centerOnZoom


- (void)centerOnZoomPoint:(CGPoint)point animated:(BOOL)animated {
  [self centerOnContentPoint:CGPointMul(point, self.zoomScale) animated:animated];
}


- (void)centerOnZoomPoint:(CGPoint)point {
  [self centerOnZoomPoint:point animated:NO];
}


- (void)centerOnZoomRect:(CGRect)rect animated:(BOOL)animated {
  [self centerOnContentRect:CGRectMul(rect, self.zoomScale) animated:animated];
}


- (void)centerOnZoomRect:(CGRect)rect {
  [self centerOnZoomRect:rect animated:NO];
}


- (void)centerOnZoomRect:(CGRect)rect point:(CGPoint)point animated:(BOOL)animated {
  CGFloat z = self.zoomScale;
  [self centerOnContentRect:CGRectMul(rect, z) point:CGPointMul(point, z) animated:animated];
}


- (void)centerOnZoomRect:(CGRect)rect point:(CGPoint)point {
  [self centerOnZoomRect:rect point:point animated:NO];
}


#pragma mark - constrain zoom


- (void)constrainMinZoomToInsideContent {
  CGSize bs = self.boundsSize;
  CGSize cs = self.contentSize;
  if (bs.width < 1 || bs.height < 1 || cs.width < 1 || cs.height < 1) {
    errFL(@"constrainMinZoomToInsideContent: degenerate: bounds.size: %@; contentFrameSize: %@",
          NSStringFromCGSize(bs), NSStringFromCGSize(cs));
    self.minimumZoomScale = 1;
    return;
  }
  CGFloat bar = CGSizeAspect(bs, 1);
  CGFloat car = CGSizeAspect(cs, 1);
  if (car < bar) { // self is wide/short relative to content; zoom is constrained by x.
    self.minimumZoomScale = bs.width / cs.width;
  }
  else { // self is thin/tall relative to content; zoom is constrained by y.
    self.minimumZoomScale = bs.height / cs.height;
  }
  if (self.maximumZoomScale < self.minimumZoomScale) {
    self.maximumZoomScale = self.minimumZoomScale;
  }
  if (self.zoomScale < self.minimumZoomScale) {
    self.zoomScale = self.minimumZoomScale;
  }
}


- (void)setZoomScaleClamped:(float)scale animated:(BOOL)animated {
  [self setZoomScale:CLAMP(scale, self.minimumZoomScale, self.maximumZoomScale) animated:animated];
}


- (void)setZoomScaleClamped:(float)scale {
  [self setZoomScaleClamped:scale animated:NO];
}


@end
