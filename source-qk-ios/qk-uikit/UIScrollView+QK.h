// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <UIKit/UIKit.h>


@interface UIScrollView (QK)

@property (nonatomic, readonly) CGRect contentFrame;
@property (nonatomic, readonly) CGPoint contentCenter;

- (void)centerOn:(CGPoint)point;

@end
