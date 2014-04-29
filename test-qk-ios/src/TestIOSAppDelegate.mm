// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "UINavigationController+QK.h"
#import "RootController.h"
#import "TestScrollController.h"
#import "TestIOSAppDelegate.h"


@implementation TestIOSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  auto n = [UINavigationController withRoot:[RootController new]];
  [self setupWindowWithRoot:n];
  n.navigationBar.translucent = NO;
  return YES;
}


@end
