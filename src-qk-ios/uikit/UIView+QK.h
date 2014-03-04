// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "CUIView.h"


@interface UIView (QK)

- (void)setupLayer;
- (UIImage*)renderedImage;
- (UIImageView*)renderedImageView;

- (void)animateRenderedFromFrame:(CGRect)fromFrame
                           alpha:(CGFloat)alpha
                        duration:(CGFloat)duration
                      completion:(void (^)(BOOL finished))completionBlock;

@end
