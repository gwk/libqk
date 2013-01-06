// Copyright George King 2013
// All rights reserved


#import "UINavigationController+QK.h"


@implementation UINavigationController (QK)


+ (id)withRoot:(UIViewController*)rootController {
  return [[self alloc] initWithRootViewController:rootController];
}


@end

