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


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  [super setDelegate:self];
  self.zoomView = [UIView withFrame:CGRectWithS(self.contentSize)];
  [self addSubview:self.zoomView];
  _constantScaleSet = [NSMutableSet new];
  return self;
}


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


#pragma mark - UIScrollViewDelegate

#define DEL_RESPONDS(sel) ([self.delegate respondsToSelector:@selector(sel)] ? self.delegate : nil)
#define DEL_PASS1(sel) [DEL_RESPONDS(sel:) sel:scrollView]
#define DEL_PASS2(sel1, sel2) [DEL_RESPONDS(sel1:sel2:) sel1:scrollView sel2:sel2]
#define DEL_PASS3(sel1, sel2, sel3) [DEL_RESPONDS(sel1:sel2:sel3:) sel1:scrollView sel2:sel2 sel3:sel3]


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


// rect in scroll view system.
- (CGSize)zoomSize {
  return self.zoomView.bounds.size;
}


@end

