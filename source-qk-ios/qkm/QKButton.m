// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "QKLitView.h"
#import "QKButton.h"


@interface QKButton ()

@property (nonatomic) BOOL isHighlightOffPending;
@property (nonatomic) NSMutableSet* litSubviews;

@end


@implementation QKButton


#pragma mark - UIResponder


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.isLit = YES;
  [self.layer setNeedsDisplay]; // lets us detect when the highlight has drawn, to ensure UI feedback.
  if (_blockTouchDown) {
    _blockTouchDown();
  }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self setHighlightedOff];
  if (_blockTouchUp) {
    for (UITouch* t in touches) {
      CGPoint p = [t locationInView:t.view];
      if ([self pointInside:p withEvent:event]) {
        _blockTouchUp();
        return;
      }
    }
  }
  if (_blockTouchCancelled) {
    _blockTouchCancelled();
  }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self setHighlightedOff];
  if (_blockTouchCancelled) {
    _blockTouchCancelled();
  }
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  self.userInteractionEnabled = YES;
  return self;
}


- (void)willRemoveSubview:(UIView *)subview {
  [_litSubviews removeObject:subview];
}


- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  for (UIView<QKLitView>* v in _litSubviews) {
    v.isLit = highlighted;
  }
}


#pragma mark - QKLitView


#pragma mark - QKLabel


#pragma mark - QKButton


- (void)addLitSubview:(UIView<QKLitView> *)view {
  [super addSubview:view];
  if (!_litSubviews) {
    _litSubviews = [NSMutableSet new];
  }
  [_litSubviews addObject:view];
  view.isLit = _isLit;
}


// private helper ensures (mostly) that a highlight is visible even if the touch up happens before redisplay.
- (void)setHighlightedOff {
  if (self.layer.needsDisplay) { // delay removing the highlight until it has become visible to the user.
    _isLit = NO; // set the bit but do not invoke visual update yet.
    [self performSelector:@selector(removeLingeringHighlight) withObject:nil afterDelay:0.1 inModes:@[NSRunLoopCommonModes]];
  }
  else {
    self.isLit = NO;
  }
}


- (void)removeLingeringHighlight {
  if (!_isLit) { // highlighting is still appropriate.
    // self.layer.needsDisplay seems to always be reset by this time, even if the highlight is not yet visible.
    // since this does not have to be perfect, just try to set it now and be done.
    self.isLit = NO;
  }
}


@end

