// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIViewController+QK.h"


@implementation UIViewController (QK)


- (void)push:(UIViewController*)controller {
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)pop {
  [self.navigationController popViewControllerAnimated:YES];
}


@end

