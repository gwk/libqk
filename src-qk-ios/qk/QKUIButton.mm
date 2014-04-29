// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "UIImage+QK.h"
#import "QKUIButton.h"


@interface QKUIButton ()
@end


@implementation QKUIButton


#pragma mark - UIView


- (instancetype)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
  [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
  [self addTarget:self action:@selector(touchCanceled) forControlEvents:UIControlEventTouchCancel];
  return self;
}


#pragma mark - QKUIButton


- (void)setupBasicColors {
  self.disabledBackgroundImage = [UIImage withColor:[UIColor l:.65]];
  self.backgroundImage = [UIImage withColor:[UIColor l:.7]];
  self.litBackgroundImage = [UIImage withColor:[UIColor l:.75]];
  self.disabledTitleColor = [UIColor l:.8];
  self.titleColor  = [UIColor l:.9];
  self.litTitleColor = [UIColor w];
}


- (void)touchDown {
  if (_blockTouchDown) {
    _blockTouchDown();
  }
}


- (void)touchUp {
  if (_blockTouchUp) {
    _blockTouchUp();
  }
}


- (void)touchCanceled {
  if (_blockTouchCanceled) {
    _blockTouchCanceled();
  }
}


@end

