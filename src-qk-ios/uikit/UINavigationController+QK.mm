// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "UINavigationController+QK.h"


@implementation UINavigationController (QK)


+ (instancetype)withRoot:(UIViewController*)rootController {
  return [[self alloc] initWithRootViewController:rootController];
}


- (void)push:(UIViewController*)controller {
  [self pushViewController:controller animated:YES];
}


- (void)replaceTopWith:(UIViewController*)controller {
    NSMutableArray* a = self.viewControllers.mutableCopy;
    [a replaceObjectAtIndex:a.lastIndex withObject:controller];
    [self setViewControllers:a animated:YES];
}

@end

