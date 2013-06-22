// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-cg-util.h"
#import "NSArray+QK.h"
#import "QKScrollView.h"


@interface QKScrollView ()

//@property (nonatomic) BOOL isScrolling;
@property (nonatomic) UIView* eventForwardingSubview;

@end


@implementation QKScrollView


#pragma mark - UIResponder


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  qk_assert(touches.count == 1, @"expected a single touch");
  UITouch* principalTouch = touches.anyObject;
  qk_assert(!_eventForwardingSubview, @"forwarding already in progress");
  UIView* hitView = [super hitTest:[principalTouch locationInView:self] withEvent:event];
  if (hitView != self) {
    _eventForwardingSubview = hitView;
    [_eventForwardingSubview touchesBegan:touches withEvent:event];
  }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [_eventForwardingSubview touchesCancelled:touches withEvent:event];
  _eventForwardingSubview = nil;
  NSArray* allTouches = event.allTouches.allObjects;
  //LOG(allTouches);
  UITouch* touch0 = allTouches[0];
  CGPoint curr0 = [touch0 locationInView:self];
  CGPoint prev0 = [touch0 previousLocationInView:self];
  if (allTouches.count == 1) {
    CGPoint op = self.contentOffset; // offset prev
    CGPoint oc = op; // offset current
    if (_scrollHorizontal) {
      oc.x = op.x - (curr0.x - prev0.x);
    }
    if (_scrollVertical) {
      oc.y = op.y - (curr0.y - prev0.y);
    }
    if (!_scrollBounce) {
      CGPoint om = self.contentOffsetMax;
      oc = CGPointMake(CLAMP(oc.x, 0, om.x), CLAMP(oc.y, 0, om.y));
    }
    CGPoint delta = sub(oc, op);
    if (delta.x || delta.y) {
      self.contentOffset = oc;
      [self scrolled:delta];
    }
  }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [_eventForwardingSubview touchesEnded:touches withEvent:event];
  _eventForwardingSubview = nil;
  [self bounce];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [_eventForwardingSubview touchesCancelled:touches withEvent:event];
  _eventForwardingSubview = nil;
  [self bounce];
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  _scrollHorizontal = YES;
  _scrollVertical = YES;
  _scrollBounce = YES;
  self.backgroundColor = [UIColor l:.5];
  return self;
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  return self; // never recurse
}


#pragma mark - QKScrollView


PROPERTY_STRUCT_FIELD(CGPoint, contentOffset, ContentOffset, CGRect, self.bounds, origin);
PROPERTY_STRUCT_FIELD(CGFloat, contentHeight, ContentHeight, CGSize, _contentSize, height);

- (CGPoint)contentOffsetMax {
  CGSize bs = self.bounds.size;
  CGSize cs = _contentSize;
  return CGPointMake(cs.width - bs.width, cs.height - bs.height);
}


- (void)bounce {
  if (!_scrollBounce) {
    return;
  }
  CGPoint oc = self.contentOffset; // offset current
  CGPoint om = self.contentOffsetMax;
  if (_scrollBounce && (oc.x < 0 || oc.x > om.x || oc.y < 0 || oc.y > om.y)) { // out of bounds
    CGPoint o = CGPointMake(CLAMP(oc.x, 0, om.x), CLAMP(oc.y, 0, om.y));
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       self.contentOffset = o;
                     }
                     completion:nil];
  }
}


- (void)scrolled:(CGPoint)offset {}


@end

