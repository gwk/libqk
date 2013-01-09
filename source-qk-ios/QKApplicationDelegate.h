// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKApplicationDelegate : NSObject<UIApplicationDelegate>

@property (nonatomic) UIWindow* window;
@property (nonatomic, readonly) UIViewController* rootController;
@property (nonatomic, readonly) UITabBarController* tabController; // cast of rootController

- (void)setupRootController:(UIViewController*)controller; // creates and sets up window

@end

