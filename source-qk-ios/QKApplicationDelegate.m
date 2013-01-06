// Copyright George King 2013
// All rights reserved


#import "QKApplicationDelegate.h"


@implementation QKApplicationDelegate


- (UITabBarController*)tabController {
  return CAST(UITabBarController, self.rootController);
}


- (void)setupRootController:(UIViewController*)controller {
  _rootController = controller;
  _window = [UIWindow withFrame:[[UIScreen mainScreen] applicationFrame]];
  _window.rootViewController = _rootController;
  [_window makeKeyAndVisible];
  // sdk bug? makeKeyAndVisible seems to be setting view.frame = _window.frame, which is wrong.
  _rootController.view.frame = _window.bounds;
}


@end

