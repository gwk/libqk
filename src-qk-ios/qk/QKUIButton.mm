// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
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

