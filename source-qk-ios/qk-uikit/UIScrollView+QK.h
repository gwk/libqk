// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <UIKit/UIKit.h>


@interface UIScrollView (QK)

@property (nonatomic, readonly) CGRect contentBounds;
@property (nonatomic, readonly) CGPoint contentCenter;

- (void)setContentOffsetClamped:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)setContentOffsetClamped:(CGPoint)contentOffset;
- (void)centerOnPoint:(CGPoint)point animated:(BOOL)animated;
- (void)centerOnPoint:(CGPoint)point;
- (void)centerOnRect:(CGRect)rect animated:(BOOL)animated;
- (void)centerOnRect:(CGRect)rect;
- (void)centerOnRect:(CGRect)rect point:(CGPoint)point animated:(BOOL)animated;
- (void)centerOnRect:(CGRect)rect point:(CGPoint)point;

@end
