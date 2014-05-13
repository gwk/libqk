// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "qk-log.h"
#import "CRView.h"
#import "QKViewController.h"


@interface QKViewController ()
@end


@implementation QKViewController


#pragma mark - UIViewController


- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor l:.5];
}


- (void)viewWillAppear:(BOOL)animated {
  errFL(@"viewWillAppear:%@ %@", BIT_YN(animated), self.class);
  [super viewWillAppear:animated];
  _isVisible = YES;
  _appearanceCount += 1;
  if (_appearanceCount == 1) {
    [self viewWillFirstAppear];
  }
  if (self.observesKeyboard) {
    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
    [c addObserver:self selector:@selector(handleKeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [c addObserver:self selector:@selector(handleKeyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
  }
}


- (void)viewDidAppear:(BOOL)animated {
  if (_appearanceCount == 1) {
    [self viewDidFirstAppear];
  }
}


- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  _isVisible = NO;
  if (self.observesKeyboard) {
    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
    [c removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [c removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  }
}


#pragma mark - QKViewController


- (void)viewWillFirstAppear {}
- (void)viewDidFirstAppear {}


- (BOOL)observesKeyboard {
  return NO;
}


- (void)handleKeyboardWillChange:(NSNotification *)note {
  // only animate if the keyboard state has changed.
  // this avoids unwanted animation when transferring between text views.
  BOOL visible = bit([note.name isEqualToString:UIKeyboardWillShowNotification]);
  if (bit(self.isKeyboardVisible) == visible) {
    return;
  }
  // note: we don't care about keyboard beginning frame; we animate the view from its own starting position.
  UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut; // overwritten
  NSTimeInterval duration = 0;
  CGRect kbFrameEnd   = CGRectZero;
  NSDictionary* info = note.userInfo;
  [info[UIKeyboardFrameEndUserInfoKey]          getValue:&kbFrameEnd];
  [info[UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
  [info[UIKeyboardAnimationCurveUserInfoKey]    getValue:&curve];
  
  CGRect viewFrame = self.view.frame;
  if (visible) { // reduce view frame height to top of keyboard
    CGRect kbFrameInWindow = [self.view.window convertRect:kbFrameEnd fromWindow:nil]; // convert from screen coordinate system
    CGRect kbFrame = [self.view.superview convertRect:kbFrameInWindow fromView:nil]; // convert from window coordinate system
    viewFrame.size.height = kbFrame.origin.y - viewFrame.origin.y;
  }
  else { // reset the view frame to its full height; assume that this is the equal to the bounds of the parent view.
    qk_assert(self.view.superview, @"controller root view has no superview on on keyboardW hide");
    viewFrame = self.view.superview.bounds;
  }
  // the duration that this animation should run depends on whether or not a bottom bar is visible.
  // determining this hard, so instead we check hidesBottomBarWhenPushed.
  // controllers can set this property even if there is no bar to hide.
  NSTimeInterval delay = self.hidesBottomBarWhenPushed ? 0 : duration * 0.27; // compensation for tab bar determined experimentally
  
  [UIView animateWithDuration:(duration - delay)
                        delay:(visible ? delay : 0) // only delay when keyboard is coming up
                      options:(curve |
                               UIViewAnimationOptionBeginFromCurrentState |
                               UIViewAnimationOptionOverrideInheritedDuration |
                               UIViewAnimationOptionOverrideInheritedCurve)
                   animations:^{
                     self->_isKeyboardVisible = visible;
                     [self animateViewFrame:viewFrame keyboardVisible:visible];
                   }
                   completion:^(BOOL completed){
                     [self animateViewFrame:viewFrame keyboardVisible:visible completed:completed];
                   }];
}


- (void)animateViewFrame:(CGRect)viewFrame keyboardVisible:(BOOL)visible {
  self.view.frame = viewFrame;
}


- (void)animateViewFrame:(CGRect)viewFrame keyboardVisible:(BOOL)visible completed:(BOOL)completed {
  //[self.view inspect:@"animateViewFrame completed"];
}


#pragma mark contentView


@end

