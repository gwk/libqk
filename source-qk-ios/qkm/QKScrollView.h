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

- (void)zoomOutAnimated:(BOOL)animated;

#if QKScrollView_USE_LEGACY_GL
// temporary
@property (nonatomic, weak) GLLayer* trackingGlLayer; // tracks scroll and zoom.
- (void)updateTrackingDelegate;
#endif

@end
