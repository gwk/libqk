// Copyright 2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "NSArray+QK.h"
#import "CALayer+QK.h"
#import "CUIColor.h"
#import "NSView+QK.h"


@implementation NSView (QK)


- (CGPoint)center {
  CGRect f = self.frame;
  return CGPointMake(f.origin.x + f.size.width * .5, f.origin.y + f.size.height * .5);
};


- (void)setCenter:(CGPoint)center {
  CGRect f = self.frame;
  f.origin = CGPointMake(center.x - f.size.width * .5, center.y - f.size.height * .5);
  self.frame = f;
}


+ (Class)layerClass {
  return [CALayer class];
}


PROPERTY_ALIAS(CUIColor*, backgroundColor, BackgroundColor, self.layer.color);
PROPERTY_ALIAS(BOOL, opaque, Opaque, self.layer.opaque);


- (void)macSetupLayer:(CALayer*)layer {
  if (self.layer) return;
  self.layer = layer;
  self.layer.delegate = self;
  self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
  self.layer.needsDisplayOnBoundsChange = YES;
  self.wantsLayer = YES; // for layer-hosting view behavior (programmatic layer), call setWantsLayer: after setLayer:.
  
  // TODO: does GLLayer ignore this?
  self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawBeforeViewResize;
  self.layer.minificationFilter = kCAFilterNearest;
  self.layer.magnificationFilter = kCAFilterNearest;
}


- (void)setupLayer {
  [self macSetupLayer:[[self.class layerClass] new]];
}


- (void)setNeedsDisplay {
  [self setNeedsDisplay:YES];
}


- (void)setNeedsLayout {
  [self setNeedsLayout:YES];
}


- (void)insertSubview:(NSView*)view atIndex:(Int)index {
  // matches UIView method.
  auto views = self.subviews;
  qk_assert(index >= 0 && index <= views.count, @"invalid subview insertion index: %ld", index);
  NSView* v = [self.subviews elOrNil:index];
  if (v) {
    [self addSubview:view positioned:NSWindowBelow relativeTo:view];
  }
  else {
    [self addSubview:view];
  }
}


@end
