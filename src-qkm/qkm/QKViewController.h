// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIViewController+QK.h"


@interface QKViewController : UIViewController

@property(nonatomic, readonly) BOOL isVisible; // automatically set by viewWillAppear/viewDidDisappear.
@property(nonatomic, readonly) BOOL isKeyboardVisible; // 
@property(nonatomic, readonly) int appearanceCount;
@property(nonatomic) UIView* contentView; // immediate child of view; automatically resized to match top/bottomLayoutGuide.

+ (BOOL)autoLayoutContentView; // defaults to YES; override to NO if contentView should not resize to insetFrame on layout.
- (void)viewWillFirstAppear;  // defaults to nothing.
- (void)viewDidFirstAppear;   // defaults to nothing.
- (BOOL)observesKeyboard; // override to YES to get keyboard tracking callbacks.
- (void)animateViewFrame:(CGRect)viewFrame keyboardVisible:(BOOL)visible; // defaults to update viewFrame. override for additional behavior.
- (void)animateViewFrame:(CGRect)viewFrame keyboardVisible:(BOOL)visible completed:(BOOL)completed; // defaults to nothing.


@end

