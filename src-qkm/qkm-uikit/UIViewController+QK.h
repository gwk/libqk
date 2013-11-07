// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIViewController (QK)

// top/bottomLayoutGuide wrappers.
@property(nonatomic, readonly) CGFloat insetTop;
@property(nonatomic, readonly) CGFloat insetBottom;
@property(nonatomic, readonly) CGRect insetFrame;

- (void)push:(UIViewController*)controller;
- (void)pop;
- (void)present:(UIViewController*)controller;
- (void)dismiss;
- (void)dismissPresented;
- (NSString*)closeButtonTitle;

@end

