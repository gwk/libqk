// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


@interface QKScrollView : UIScrollView <UIScrollViewDelegate>

- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale;
- (void)addZoomSubview:(UIView*)view;

// content size in the zoom view coordinate system.
- (CGRect)zoomContentRect;
- (CGSize)zoomContentSize; // zoomContentRect.size
- (CGPoint)zoomContentCenter;
- (CGPoint)zoomBoundsCenter; // center of the visible portion of the content in the zoomView coordinate system.

- (void)zoomOutAnimated:(BOOL)animated;

@end
