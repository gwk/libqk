// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLLayer.h"


@protocol QKScrollTrackingDelegate;


@interface QKScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) GLLayer* trackingGlLayer; // tracks scroll and zoom.

- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale;
- (void)addZoomSubview:(UIView*)view;

- (void)updateTrackingDelegate;

// content size in the zoom view coordinate system.
- (CGRect)zoomContentRect;
- (CGSize)zoomContentSize; // zoomContentRect.size

- (void)zoomOutAnimated:(BOOL)animated;

@end


@protocol QKScrollTrackingDelegate <NSObject>

- (void)trackScrollBounds:(CGRect)scrollBounds
              contentSize:(CGSize)size
                   insets:(UIEdgeInsets)insets
                zoomScale:(CGFloat)zoomScale;

@end
