// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLLayer.h"


@protocol QKScrollTrackingDelegate;


@interface QKScrollView : UIScrollView <UIScrollViewDelegate>

- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale;
- (void)addZoomSubview:(UIView*)view;

// content size in the zoom view coordinate system.
- (CGRect)zoomContentRect;
- (CGSize)zoomContentSize; // zoomContentRect.size

- (void)zoomOutAnimated:(BOOL)animated;

// temporary
@property (nonatomic, weak) GLLayer* trackingGlLayer; // tracks scroll and zoom.
- (void)updateTrackingDelegate;

@end
