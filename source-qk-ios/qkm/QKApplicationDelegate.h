// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIApplication+QK.h"


@interface QKApplicationDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow* window;
@property (nonatomic, readonly) UIViewController* rootController;
@property (nonatomic, readonly) UITabBarController* tabController; // cast of rootController

- (void)setupRootController:(UIViewController*)controller; // creates and sets up window

@end

