// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#if QKScrollView_USE_LEGACY_GL
#import "GLLayer.h"
#endif

@protocol QKScrollTrackingDelegate;


@interface QKScrollView : UIScrollView <UIScrollViewDelegate>

- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale;
- (void)addZoomSubview:(UIView*)view;

// content size in the zoom view coordinate system.
- (CGRect)zoomContentRect;
- (CGSize)zoomContentSize; // zoomContentRect.size
- (CGPoint)zoomContentCenter;
- (CGPoint)zoomBoundsCenter; // center of the visible portion of the content in the zoomView coordinate system.

- (void)zoomOutAnimated:(BOOL)animated;

#if QKScrollView_USE_LEGACY_GL
// temporary hack until scroll views are implemented purely in gl.
@property (nonatomic, weak) GLLayer* trackingGlLayer; // tracks scroll and zoom.
- (void)updateTrackingDelegate;
#endif

@end
