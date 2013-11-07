// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


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


// NSView already defines setBoundsOrigin; define the accessor to match the PROPERTY_STRUCT_FIELD declaration in UIView+QK.
- (CGPoint)boundsOrigin {
  return self.bounds.origin;
}


// NSView already defines setBoundsSize; define the accessor to match the PROPERTY_STRUCT_FIELD declaration in UIView+QK.
- (CGSize)boundsSize {
  return self.bounds.size;
}


+ (Class)layerClass {
  return [CALayer class];
}


PROPERTY_ALIAS(CUIColor*, backgroundColor, BackgroundColor, self.layer.backgroundUIColor);


- (void)macSetupLayer:(CALayer*)layer {
  if (self.layer) return;
  self.layer = layer;
  self.layer.delegate = self;
  self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
  self.layer.needsDisplayOnBoundsChange = YES;
  self.wantsLayer = YES; // set wantsLayer after layer for layer-hosting view behavior (programmatic layer).
  
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


@end
