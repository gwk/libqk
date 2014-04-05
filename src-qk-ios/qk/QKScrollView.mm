// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "qk-log.h"
#import "qk-cg-util.h"
#import "NSString+QK.h"
#import "NSArray+QK.h"
#import "CUIView.h"
#import "UIScrollView+QK.h"
#import "QKScrollView.h"


@interface QKScrollView ()

@property (nonatomic) UIView* zoomView;
@property (nonatomic) NSMutableSet* constantScaleSet;

@end


@implementation QKScrollView


// use unique name because property name collides with existing ivars (ios6).
@synthesize zoomView = _zoomViewQKScrollView;


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %@ %@>",
          self.class, self, NSStringFromCGRect(self.frame), self.layer];
}


#pragma mark - UIResponder

/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 LOG_METHOD;
 [super touchesBegan:touches withEvent:event];
 }
 
 
 - (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
 UIView* hitView = [super hitTest:point withEvent:event];
 LOG(hitView);
 return hitView;
 }
 */

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // double-tap to zoom in; twin-tap to zoom out.
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


- (instancetype)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  [super setDelegate:self];
  _zoomViewQKScrollView = [UIView withFrame:CGRectWithS(self.contentSize)];
  [self addSubview:_zoomViewQKScrollView];
  _constantScaleSet = [NSMutableSet new];
  return self;
}


#pragma mark - UIScrollView


- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
  qk_assert(delegate == nil || delegate == self, @"QKScrollView must be its own delegate (set automatically); use blocks instead.");
  [super setDelegate:delegate];
}


- (void)setContentSize:(CGSize)contentSize {
  [super setContentSize:contentSize];
  _zoomViewQKScrollView.s = self.contentSize;
}


#pragma mark - UIScrollViewDelegate


- (void)logState {
  errFL(@"scroll view: b: %@; co: %@; cs: %@; zcr: %@; zs: %f",
        NSStringFromCGRect(self.bounds), NSStringFromCGPoint(self.contentOffset), NSStringFromCGSize(self.contentSize),
        NSStringFromCGRect(self.zoomContentRect), self.zoomScale);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // TODO: call block.
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  CGFloat s = 1.0 / self.zoomScale;
  for (UIView* v in _constantScaleSet) {
    v.transform = CGAffineTransformMakeScale(s, s);
  }
  // TODO: call block.
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  // TODO: call block.
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)withVelocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
  // TODO: call block.
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
  // TODO: call block.
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  // TODO: call block.
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  // TODO: call block.
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)withView {
  // TODO: call block.
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)withView atScale:(CGFloat)atScale {
  // TODO: call block.
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _zoomViewQKScrollView;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  // TODO: call block.
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  // TODO: call block.
  return YES;
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  // TODO: call block.
}


#pragma mark - QKScrollView


- (CGPoint)contentOffsetMax {
  CGSize bs = self.bounds.size;
  CGSize cs = self.contentSize;
  return CGPointMake(cs.width - bs.width, cs.height - bs.height);
}



- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale {
  [_zoomViewQKScrollView addSubview:view];
  if (constantScale) {
    [_constantScaleSet addObject:view];
  }
}


- (void)addZoomSubview:(UIView*)view {
  [self addZoomSubview:view constantScale:NO];
}


- (CGRect)zoomContentRect {
  return _zoomViewQKScrollView.bounds;
}


- (CGSize)zoomContentSize {
  return _zoomViewQKScrollView.bounds.size;
}


- (CGPoint)zoomContentOffset {
  return mul(self.contentOffset, 1.0 / self.zoomScale);
}


- (CGPoint)zoomContentCenter {
  return _zoomViewQKScrollView.bc;
}


- (CGPoint)zoomBoundsCenter {
  return mul(self.bc, 1.0 / self.zoomScale);
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

