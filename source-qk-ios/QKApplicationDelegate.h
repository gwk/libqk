// Copyright George King 2013
// All rights reserved


@interface QKApplicationDelegate : NSObject<UIApplicationDelegate>

@property (nonatomic) UIWindow* window;
@property (nonatomic, readonly) UIViewController* rootController;
@property (nonatomic, readonly) UITabBarController* tabController; // cast of rootController

- (void)setupRootController:(UIViewController*)controller; // creates and sets up window

@end

