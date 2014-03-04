// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "UIBarButtonItem+QK.h"
#import "UINavigationController+QK.h"
#import "UIViewController+QK.h"


@implementation UIViewController (QK)


- (CGFloat)insetTop {
  return [self.topLayoutGuide length];
}


- (CGFloat)insetBottom {
  return [self.bottomLayoutGuide length];
}


- (CGRect)insetFrame {
  CGRect r = self.view.frame;
  CGFloat t = self.insetTop;
  CGFloat b = self.insetBottom;
  return CGRectMake(r.origin.x, r.origin.y + t, r.size.width, r.size.height - (t + b));
}


- (void)push:(UIViewController*)controller {
  qk_assert(self.navigationController, @"no navigation controller to push onto: %@", self);
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)pop {
  qk_assert(self.navigationController, @"no navigation controller to pop from: %@", self);
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)popAndClearSender:(id)sender {
  // TODO: call dissolve instead and implement dissolve for the various classes?
  if ([sender respondsToSelector:@selector(removeTarget:action:)]) { // UIGestureRecognizer
    [sender removeTarget:nil action:NULL];
  }
  else if ([sender respondsToSelector:@selector(removeTarget:action:forControlEvents:)]) { // UIControl
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
  }
  // TODO: QKButton?
  [self pop];
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

