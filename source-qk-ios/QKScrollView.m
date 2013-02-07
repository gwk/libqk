// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-cg-util.h"
#import "QKScrollView.h"


@interface QKScrollView ()

@property (nonatomic) UIView* zoomView;
@property (nonatomic, weak) id<UIScrollViewDelegate> delegate;
@property (nonatomic) NSMutableSet* constantScaleSet;

@end


@implementation QKScrollView


// use unique names for these ivars, because property names collide with existing ivars.
@synthesize
delegate = _delegateQKScrollView,
zoomView = _zoomViewQKScrollView;


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  [super setDelegate:self];
  self.zoomView = [UIView withFrame:CGRectWithS(self.contentSize)];
  [self addSubview:self.zoomView];
  _constantScaleSet = [NSMutableSet new];
  return self;
}


#pragma mark - UIScrollView


- (void)setContentSize:(CGSize)contentSize {
  self.zoomView.size = contentSize;
  [super setContentSize:contentSize];
}


- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale {
  [self.zoomView addSubview:view];
  if (constantScale) {
    [_constantScaleSet addObject:view];
  }
}


- (void)addZoomSubview:(UIView*)view {
  [self addZoomSubview:view constantScale:NO];
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  DEL_PASS1(scrollViewDidScroll);
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  CGFloat s = 1.0 / self.zoomScale;
  for (UIView* v in _constantScaleSet) {
    v.transform = CGAffineTransformMakeScale(s, s);
  }
  DEL_PASS1(scrollViewDidZoom);
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  DEL_PASS1(scrollViewWillBeginDragging);
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)withVelocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
  DEL_PASS3(scrollViewWillEndDragging, withVelocity, targetContentOffset);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
  DEL_PASS2(scrollViewDidEndDragging, willDecelerate);
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  DEL_PASS1(scrollViewWillBeginDecelerating);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  DEL_PASS1(scrollViewDidEndDecelerating);
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)withView {
  DEL_PASS2(scrollViewWillBeginZooming, withView);
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)withView atScale:(float)atScale {
  DEL_PASS3(scrollViewDidEndZooming, withView, atScale);
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.zoomView;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  DEL_PASS1(scrollViewDidEndScrollingAnimation);
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  return [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]
  ? [self.delegate scrollViewShouldScrollToTop:scrollView]
  : YES;
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  DEL_PASS1(scrollViewDidScrollToTop);
}


#pragma mark - QKScrollView


- (CGRect)zoomContentRect {
  return self.zoomView.bounds;
}


#pragma mark zoom


- (UIEdgeInsets)interactionInsetsInZoomSystem {
  CGFloat z = 1.0 / self.zoomScale; 
  UIEdgeInsets e = _interactionInsets;
  return UIEdgeInsetsMake(-z * e.top, -z * e.left, -z * e.bottom, -z * e.right);
}


- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
  // TODO: respect interactionInsets.
  // the solution is not so simple because the interactionInsetsInZoomSystem uses the old zoomScale,
  // but it seems to need the z value that we solve for below.
  //[self addZoomSubview:[UIView withFrame:rect color:[UIColor l:0 a:.3]]];
  CGRect validRect = CGRectIntersection(rect, self.zoomView.bounds);
  if (CGRectIsEmpty(validRect)) {
    errFL(@"zoomToRect: invalid rect: %@", NSStringFromCGRect(rect));
  }
  CGSize bs = self.bounds.size;
  CGRect r = CGRectWithAspectEnclosingRect(CGSizeAspect(bs), validRect);
  CGFloat z = bs.width / r.size.width;
  [self setZoomScaleClamped:z animated:animated];
  [self centerOnZoomRect:r animated:animated];
}


- (void)zoomToRect:(CGRect)rect {
  [self zoomToRect:rect animated:NO];
}


- (void)zoomOutAnimated:(BOOL)animated {
  [self zoomToRect:self.zoomContentRect animated:animated];
}


@end

