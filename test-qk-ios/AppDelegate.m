// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UINavigationController+QK.h"
#import "RootController.h"
#import "TestScrollController.h"
#import "AppDelegate.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setupRootController:[UINavigationController withRoot:[RootController new]]];
  return YES;
}


@end
