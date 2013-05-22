// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "QKHighlightingView.h"
#import "QKButton.h"


@interface QKButton ()

@property (nonatomic) NSMutableSet* highlightingSubviews;
@property (nonatomic) BOOL isHighlightOffPending;

@end


@implementation QKButton


#pragma mark - UIResponder


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.highlighted = YES;
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


- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [self setColor:backgroundColor];
  [self setHighlightedColor:backgroundColor];
}


- (void)willRemoveSubview:(UIView *)subview {
  [_highlightingSubviews removeObject:subview];
}


#pragma mark - QKButton


- (void)setColor:(UIColor *)color {
  _color = color;
  if (!_highlighted) {
    [super setBackgroundColor:color];
  }
}


- (void)setHighlightedColor:(UIColor *)highlightedColor {
  _highlightedColor = highlightedColor;
  if (_highlighted) {
    [super setBackgroundColor:highlightedColor];
  }
}


- (void)setHighlighted:(BOOL)highlighted {
  _highlighted = highlighted;
  [super setBackgroundColor:(highlighted ? _highlightedColor : _color)];
  for (UIView<QKHighlightingView>* v in _highlightingSubviews) {
    v.highlighted = highlighted;
  }
}


- (void)setHighlightedOff {
  if (self.layer.needsDisplay) { // delay removing the highlight until it has become visible to the user.
    _highlighted = NO; // set the bit but do not invoke visual update yet.
    [self performSelector:@selector(removeLingeringHighlight) withObject:nil afterDelay:0.1 inModes:@[NSRunLoopCommonModes]];
  }
  else {
    self.highlighted = NO;
  }
}


- (void)removeLingeringHighlight {
  if (!_highlighted) { // still appropriate
    // self.layer.needsDisplay seems to always be reset by this time, even if the highlight is not yet visible.
    // since this does not have to be perfect, just try to set it now and be done.
    self.highlighted = NO;
  }
}


- (void)addSubview:(UIView *)view highlights:(BOOL)highlights {
  [super addSubview:view];
  if (highlights) {
    [CAST_PROTO(QKHighlightingView, view) setHighlighted:_highlighted];
    [_highlightingSubviews addObject:view];
  }
}


@end

