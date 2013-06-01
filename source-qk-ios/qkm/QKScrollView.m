// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-cg-util.h"
#import "NSArray+QK.h"
#import "CUIView.h"
#import "UIScrollView+QK.h"
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


#pragma mark - UIResponder


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  NSArray* allTouches = event.allTouches.allObjects;
  UITouch* touch0 = [allTouches el:0];
  if (allTouches.count == 1 && touch0.tapCount == 2) {
    [self setZoomScale:self.zoomScale * 2 animated:YES];
    return;
  }
  if (allTouches.count == 2) {
    UITouch* touch1 = [allTouches el:1];
    if (touch0.tapCount == 1 && touch1.tapCount == 1) {
      [self setZoomScale:self.zoomScale * .5 animated:YES];
      return;
    }
  }
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  [super setDelegate:self];
  _zoomViewQKScrollView = [UIView withFrame:CGRectWithS(self.contentSize)];
  [self addSubview:_zoomViewQKScrollView];
  _constantScaleSet = [NSMutableSet new];
  return self;
}


#pragma mark - UIScrollView

#if QKScrollView_USE_LEGACY_GL


#define UPDATE_TRACKING_DELEGATE \
[_trackingGlLayer trackScrollBounds:self.bounds contentSize:self.contentSize zoomScale:self.zoomScale];


- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  UPDATE_TRACKING_DELEGATE;
}


- (void)setContentOffset:(CGPoint)contentOffset {
  [super setContentOffset:contentOffset];
  UPDATE_TRACKING_DELEGATE;
}


- (void)setContentSize:(CGSize)contentSize {
  [super setContentSize:contentSize];
  _zoomViewQKScrollView.size = self.contentSize;
  UPDATE_TRACKING_DELEGATE;
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
  [super setContentInset:contentInset];
  UPDATE_TRACKING_DELEGATE;
}


- (void)setZoomScale:(float)zoomScale {
  [super setZoomScale:zoomScale];
  UPDATE_TRACKING_DELEGATE;
}

#endif

#pragma mark - UIScrollViewDelegate


- (void)logState {
  errFL(@"scroll view: b: %@; co: %@; cs: %@; zcr: %@; zs: %f",
        NSStringFromCGRect(self.bounds), NSStringFromCGPoint(self.contentOffset), NSStringFromCGSize(self.contentSize),
        NSStringFromCGRect(self.zoomContentRect), self.zoomScale);
}


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
  return _zoomViewQKScrollView;
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


- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale {
  [_zoomViewQKScrollView addSubview:view];
  if (constantScale) {
    [_constantScaleSet addObject:view];
  }
}


- (void)addZoomSubview:(UIView*)view {
  [self addZoomSubview:view constantScale:NO];
}


#if QKScrollView_USE_LEGACY_GL
- (void)updateTrackingDelegate {
  // hack for iOS 5 bug
  UPDATE_TRACKING_DELEGATE;
}
#endif


- (CGRect)zoomContentRect {
  return _zoomViewQKScrollView.bounds;
}


- (CGSize)zoomContentSize {
  return _zoomViewQKScrollView.bounds.size;
}


- (CGPoint)zoomContentOffset {
  return CGPointMul(self.contentOffset, 1.0 / self.zoomScale);
}


- (CGPoint)zoomContentCenter {
  return _zoomViewQKScrollView.boundsCenter;
}


- (CGPoint)zoomBoundsCenter {
  return CGPointMul(self.boundsCenter, 1.0 / self.zoomScale);
}


#pragma mark zoom


- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
  //[self addZoomSubview:[UIView withFrame:rect color:[UIColor l:0 a:.3]]];
  CGRect validRect = CGRectIntersection(rect, _zoomViewQKScrollView.bounds);
  if (CGRectIsEmpty(validRect)) {
    errFL(@"zoomToRect: invalid rect: %@", NSStringFromCGRect(rect));
    return;
  }
  CGSize bs = self.bounds.size;
  CGRect r = CGRectWithAspectEnclosingRect(CGSizeAspect(bs, 1), validRect);
  CGFloat z = bs.width / r.size.width;
  
  // TODO: implement animation.
  // separate animations cause mild distortion in animation paths of the markers.
  // instead wrap these two calls in animation block.
  if (animated) errFL(@"zoomToRect animation not yet implemented");
  [self setZoomScaleClamped:z animated:NO];
  [self centerOnZoomRect:r animated:NO];
}


- (void)zoomOutAnimated:(BOOL)animated {
  [self zoomToRect:self.zoomContentRect animated:animated];
}


@end

