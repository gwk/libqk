// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <GLKit/GLKit.h>
#import "qk-types.h"
#import "qk-vec.h"
#import "NSString+QK.h"
#import "NSArray+QK.h"
#import "GLLayer.h"
#import "GLView.h"
#import "GLEventHandler.h"


#if TARGET_OS_IPHONE // silence warning on mac
static F32 minScaleDistance = 4;
#endif


@interface GLEventHandler ()
@end


@implementation GLEventHandler


- (id)init {
  INIT(super init);
  return self;
}


#if TARGET_OS_IPHONE
- (BOOL)touchesBegan:(UIEvent*)event view:(GLView*)view {
  return NO;
}


- (BOOL)touchesMoved:(UIEvent*)event view:(GLView*)view {
  GLLayer* layer = view.glLayer;
  id<GLSceneScroll2> scene = CAST_PROTO(GLSceneScroll2, layer.scene);
  V2 layerSize = V2F32WithCGSize(layer.bounds.size);
  NSArray* allTouches = event.allTouches.allObjects;
  //LOG(allTouches);
  UITouch* touch0 = [allTouches el:0];
  V2 curr0 = V2F32WithCGPoint([touch0 locationInView:view]);
  V2 prev0 = V2F32WithCGPoint([touch0 previousLocationInView:view]);
  
  if (allTouches.count == 1) {
    [scene adjustTranslation:V2Sub(curr0, prev0) layerSize:layerSize];
  }
  else if (allTouches.count == 2) {
    UITouch* touch1 = [allTouches el:1];
    V2 curr1 = V2F32WithCGPoint([[allTouches objectAtIndex:1] locationInView:view]);
    V2 prev1 = V2F32WithCGPoint([touch1 previousLocationInView:view]);
    V2 curr = V2Mean(curr0, curr1);
    V2 prev = V2Mean(prev0, prev1);
    [scene adjustTranslation:V2Sub(curr, prev) layerSize:layerSize]; // does this come first or second?
    
    F32 distCurr = V2Dist(curr0, curr1);
    F32 distPrev = V2Dist(prev0, prev1);
    
    if (distCurr > minScaleDistance && distPrev > minScaleDistance) {
      // TODO: zoom around center point (curr)
      [scene adjustScale:distCurr / distPrev around:curr layerSize:layerSize];
    }
    F32 angle = V2Angle(curr0, curr1) - V2Angle(prev0, prev1);
    [scene adjustRotation:angle];
  }
  else {
    return NO;
  }
  return YES;
}


- (BOOL)touchesEnded:(UIEvent*)event view:(GLView*)view {
  GLLayer* layer = view.glLayer;
  id<GLSceneScroll2> scene = CAST_PROTO(GLSceneScroll2, layer.scene);
  V2 layerSize = V2F32WithCGSize(layer.bounds.size);
  NSArray* allTouches = event.allTouches.allObjects;
  //LOG(allTouches);
  UITouch* touch0 = [allTouches el:0];
  V2 curr0 = V2F32WithCGPoint([touch0 locationInView:view]);
  if (allTouches.count == 1 && touch0.tapCount == 2) {
    [scene adjustScale:2 around:curr0 layerSize:layerSize];
    return YES;
  }
  if (allTouches.count == 2) {
    UITouch* touch1 = [allTouches el:1];
    V2 curr1 = V2F32WithCGPoint([[allTouches objectAtIndex:1] locationInView:view]);
    V2 curr = V2Mean(curr0, curr1);
    if (touch0.tapCount == 1 && touch1.tapCount == 1) {
      [scene adjustScale:.5 around:curr layerSize:layerSize];
      return YES;
    }
  }
  return NO;
}


- (BOOL)touchesCancelled:(UIEvent*)event view:(GLView*)view {
  return NO;
}

#endif


@end

