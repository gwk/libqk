// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "UIBarButtonItem+QK.h"
#import "UINavigationController+QK.h"
#import "UIViewController+QK.h"


@implementation UIViewController (QK)


- (void)push:(UIViewController*)controller {
  qk_assert(self.navigationController, @"no navigation controller to push onto: %@", self);
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)pop {
  qk_assert(self.navigationController, @"no navigation controller to pop from: %@", self);
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)present:(UIViewController*)controller {
  [LIVE_ELSE(self.navigationController, self) presentViewController:controller animated:YES completion:nil];
}


- (void)presentRoot:(UIViewController*)controller {
  
  controller.navigationItem.leftBarButtonItem =
  [UIBarButtonItem withTitle:controller.closeButtonTitle
                       style:UIBarButtonItemStylePlain
                      target:controller
                      action:@selector(dismiss)];
  
  [self present:[UINavigationController withRoot:controller]];
}


- (void)dismiss {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)dismissPresented {
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSString*)closeButtonTitle {
  return @"Close";
}


@end

