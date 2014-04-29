// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "CUIView.h"


@interface UIView (QK)

+ (instancetype)forAutolayout;

- (void)setupLayer;
- (UIImage*)renderedImage;
- (UIImageView*)renderedImageView;

- (void)animateRenderedFromFrame:(CGRect)fromFrame
                           alpha:(CGFloat)alpha
                        duration:(CGFloat)duration
                      completion:(void (^)(BOOL finished))completionBlock;

- (void)constrainViews:(NSDictionary*)views
               strings:(NSArray*)strings
               metrics:(NSDictionary*)metrics
               options:(NSLayoutFormatOptions)options;

- (void)constrainViews:(NSDictionary*)views strings:(NSArray*)strings metrics:(NSDictionary*)metrics;
- (void)constrainViews:(NSDictionary*)views strings:(NSArray*)strings;

@end
