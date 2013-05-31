// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UINavigationController+QK.h"
#import "RootController.h"
#import "ScrollController.h"
#import "AppDelegate.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setupRootController:[UINavigationController withRoot:[RootController new]]];
  [self.rootController push:[ScrollController new]];
  return YES;
}


@end
