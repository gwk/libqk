// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "CRView.h"
#import "QKApplicationDelegate.h"


@implementation QKApplicationDelegate


- (UITabBarController*)tabController {
  return CAST(UITabBarController, self.rootController);
}


- (void)setupWindowWithRoot:(UIViewController*)controller {
  _rootController = controller;
  _window = [UIWindow withFrame:[[UIScreen mainScreen] bounds]]; // NOT applicationFrame, despite the documentation!
  _window.rootViewController = _rootController;
  [_window makeKeyAndVisible];
}


@end

