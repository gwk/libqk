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
    CGSize bs = self.bounds.size;
    CGSize cs = self.contentSize;
    CGPoint op = self.contentOffset; // prev
    CGPoint oc = CGPointMake(_scrollHorizontal  ? CLAMP(op.x - (curr0.x - prev0.x), 0, cs.width - bs.width)     : op.x,
                             _scrollVertical    ? CLAMP(op.y - (curr0.y - prev0.y), 0, cs.height - bs.height)   : op.y);
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
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [_eventForwardingSubview touchesCancelled:touches withEvent:event];
  _eventForwardingSubview = nil;
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  _scrollHorizontal = YES;
  _scrollVertical = YES;
  return self;
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  return self; // never recurse
}


#pragma mark - QKScrollView


PROPERTY_STRUCT_FIELD(CGPoint, contentOffset, ContentOffset, CGRect, self.bounds, origin);
PROPERTY_STRUCT_FIELD(CGFloat, contentHeight, ContentHeight, CGSize, _contentSize, height);

- (void)scrolled:(CGPoint)offset {}


@end

