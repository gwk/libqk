// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UINavigationController+QK.h"
#import "RootController.h"
#import "TestScrollController.h"
#import "TestIOSAppDelegate.h"


@implementation TestIOSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setupRootController:[UINavigationController withRoot:[RootController new]]];
  return YES;
}


@end
