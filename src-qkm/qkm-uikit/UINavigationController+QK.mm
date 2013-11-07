// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UINavigationController+QK.h"


@implementation UINavigationController (QK)


+ (id)withRoot:(UIViewController*)rootController {
  return [[self alloc] initWithRootViewController:rootController];
}


- (void)push:(UIViewController*)controller {
  [self pushViewController:controller animated:YES];
}


@end

