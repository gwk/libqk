// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-cg-util.h"
#import "NSUIView.h"
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


#define UPDATE_TRACKING_DELEGATE \
[_trackingDelegate setScrollBounds:self.bounds contentSize:self.contentSize insets:self.contentInset zoomScale:self.zoomScale];
//errFL(@"b: %@; cs: %@; zs: %f", NSStringFromCGRect(self.bounds), NSStringFromCGSize(self.contentSize), self.zoomScale);


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


- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale {
  [self.zoomView addSubview:view];
  if (constantScale) {
    [_constantScaleSet addObject:view];
  }
}


- (void)addZoomSubview:(UIView*)view {
  [self addZoomSubview:view constantScale:NO];
}


- (void)setTrackingDelegate:(id<QKScrollTrackingDelegate>)trackingDelegate {
  _trackingDelegate = trackingDelegate;
  UPDATE_TRACKING_DELEGATE;
}


- (void)updateTrackingDelegate {
  // hack for iOS 5 bug
  UPDATE_TRACKING_DELEGATE;
}


- (CGRect)zoomContentRect {
  return self.zoomView.bounds;
}


- (CGSize)zoomContentSize {
  return self.zoomView.bounds.size;
}


#pragma mark zoom


- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
  //[self addZoomSubview:[UIView withFrame:rect color:[UIColor l:0 a:.3]]];
  CGRect validRect = CGRectIntersection(rect, self.zoomView.bounds);
  if (CGRectIsEmpty(validRect)) {
    errFL(@"zoomToRect: invalid rect: %@", NSStringFromCGRect(rect));
    return;
  }
  CGSize bs = self.bounds.size;
  CGRect r = CGRectWithAspectEnclosingRect(CGSizeAspect(bs, 1), validRect);
  CGFloat z = bs.width / r.size.width;
  
  // NOTE: separate animations cause mild distortion in animation paths of the markers.
  // not sure what to do about this;
  // if we do not override this method then the trackingDelegate gets no callbacks during animation.
  // even worse, on iOS 5 passing animated:YES causes weird rect on first display only.
  // for now, just do away with animations entirely.
  [self setZoomScaleClamped:z animated:NO];
  [self centerOnZoomRect:r animated:NO];
}


- (void)zoomOutAnimated:(BOOL)animated {
  [self zoomToRect:self.zoomContentRect animated:animated];
}


@end

