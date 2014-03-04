// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <UIKit/UIKit.h>


@interface UIScrollView (QK)

@property (nonatomic, readonly) CGRect contentBounds;
@property (nonatomic, readonly) CGPoint contentCenter;

- (void)setContentOffsetClamped:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)setContentOffsetClamped:(CGPoint)contentOffset;

// in the coordinate system of the scroll view.
// this matches the coordinate system of zoomed content only when zoomScale == 1.
- (void)centerOnContentPoint:(CGPoint)point animated:(BOOL)animated;
- (void)centerOnContentPoint:(CGPoint)point;
- (void)centerOnContentRect:(CGRect)rect animated:(BOOL)animated;
- (void)centerOnContentRect:(CGRect)rect;
- (void)centerOnContentRect:(CGRect)rect point:(CGPoint)point animated:(BOOL)animated;
- (void)centerOnContentRect:(CGRect)rect point:(CGPoint)point;

// in the coordinate system of zoomed content.
- (void)centerOnZoomPoint:(CGPoint)point animated:(BOOL)animated;
- (void)centerOnZoomPoint:(CGPoint)point;
- (void)centerOnZoomRect:(CGRect)rect animated:(BOOL)animated;
- (void)centerOnZoomRect:(CGRect)rect;
- (void)centerOnZoomRect:(CGRect)rect point:(CGPoint)point animated:(BOOL)animated;
- (void)centerOnZoomRect:(CGRect)rect point:(CGPoint)point;

- (void)setZoomScaleClamped:(float)scale animated:(BOOL)animated;
- (void)setZoomScaleClamped:(float)scale;
- (void)constrainMinZoomToInsideContent;

@end
