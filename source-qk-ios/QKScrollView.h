// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKScrollView : UIScrollView <UIScrollViewDelegate>

// interactionInsets defines margins to minimize occlusion of content by floating controls.
// defined in the parent coordinate system.
// i have not figured out how to actually make this work in zoomToRect yet.
@property (nonatomic) UIEdgeInsets interactionInsets;

- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale;
- (void)addZoomSubview:(UIView*)view;

// content size in the zoom view coordinate system.
- (CGSize)zoomSize;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;
- (void)zoomToRect:(CGRect)rect;

@end

