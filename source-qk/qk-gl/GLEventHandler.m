// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"
#import "NSArray+QK.h"
#import "GLLayer.h"
#import "GLView.h"
#import "GLEventHandler.h"


static F32 minScaleDistance = 4;

@interface GLEventHandler ()
@end


@implementation GLEventHandler


- (id)init {
  INIT(super init);
  _scale = 1;
  return self;
}


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: p:%@ s:%f r:%f>",
          self.class, self, V2F32Desc(_position), _scale, _rotation];
}


- (BOOL)touchesBegan:(UIEvent*)event view:(GLView*)view {
  return NO;
}


- (BOOL)touchesMoved:(UIEvent*)event view:(GLView*)view {
  NSArray* allTouches = event.allTouches.allObjects;
  //LOG(allTouches);
  UITouch* touch0 = [allTouches el:0];
  V2F32 curr0 = V2F32WithCGPoint([touch0 locationInView:view]);
  V2F32 prev0 = V2F32WithCGPoint([touch0 previousLocationInView:view]);
  
  CGFloat scaleFactor = 1.0 / (view.bounds.size.width * _scale);
  
  if (allTouches.count == 1) {
    [self adjustPosition:V2F32Mul(V2F32Sub(curr0, prev0), scaleFactor)];
  }
  else if (allTouches.count == 2) {
    UITouch* touch1 = [allTouches el:1];
    V2F32 curr1 = V2F32WithCGPoint([[allTouches objectAtIndex:1] locationInView:view]);
    V2F32 prev1 = V2F32WithCGPoint([touch1 previousLocationInView:view]);
    V2F32 curr = V2F32Mean(curr0, curr1);
    V2F32 prev = V2F32Mean(prev0, prev1);
    [self adjustPosition:V2F32Mul(V2F32Sub(curr, prev), scaleFactor)];
    
    F32 distHere = V2F32Dist(curr0, curr1);
    F32 distPrev = V2F32Dist(prev0, prev1);
    
    if (distHere > minScaleDistance && distPrev > minScaleDistance) {
      // TODO: zoom around center point (curr)
      _scale *= distHere / distPrev;
    }
    F32 angle = V2F32Angle(curr0, curr1) - V2F32Angle(prev0, prev1);
    [self adjustRotation:angle];
  }
  else {
    return NO;
  }
  return YES;
}


- (BOOL)touchesEnded:(UIEvent*)event view:(GLView*)view {
  NSArray* allTouches = event.allTouches.allObjects;
  //LOG(allTouches);
  UITouch* touch0 = [allTouches el:0];
  if (allTouches.count == 1 && touch0.tapCount == 2) {
    _scale *= .5;
    return YES;
  }
  if (allTouches.count == 2) {
    UITouch* touch1 = [allTouches el:1];
    if (touch0.tapCount == 1 && touch1.tapCount == 1) {
      _scale *= 2;
      return YES;
    }
  }
  return NO;
}


- (BOOL)touchesCancelled:(UIEvent*)event view:(GLView*)view {
  return NO;
}


//projectionMode();
//scale(1.0f / scale);
//translate(-translation);
//modelViewMode();
//rotate(-rotation);



- (void)adjustPosition:(V2F32)screenNormalizedDelta {
  screenNormalizedDelta.v[1] *= -1; // flip y
  _position = V2F32Add(_position, V2F32Mul(screenNormalizedDelta, -_scale)); // negate
}


- (F32)scalePower {
  return log(_scale) / log(2);
}


- (void)setScalePower:(F32)scalePower {
  _scale = pow(2, scalePower);
}


- (void)setRotation:(F32)r {
  _rotation = modAngle(r);
}


- (void)adjustRotation:(F32)r {
  self.rotation = _rotation + 2 * M_PI - r;
}


@end

