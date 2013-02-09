// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "QKView.h"


@interface QKView ()

@property (nonatomic) NSTimer* timer;
@property (nonatomic) NSDate*  animationStartDate;

@end


@implementation QKView


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %@ %@>",
          self.class, self, NSStringFromCGRect(self.frame), self.layer];
}


- (id)initWithFrame:(CGRect)frame {
  NON_DESIGNATED_INIT(@"initWithFrame:renderer:format:");
}


DEF_INIT(Frame:(CGRect)frame scene:(id)scene format:(QKPixFmt)format) {
  INIT(super initWithFrame:frame);
  self.scene = scene;
  if (format) {
    [self setupLayer:[[QKGLLayer alloc] initWithFormat:format scene:scene]];
  }
  else {
    [self setupLayer:[CALayer new]];
  }
  self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawBeforeViewResize;
  self.layer.minificationFilter = kCAFilterNearest;
  self.layer.magnificationFilter = kCAFilterNearest;

  //[self.layer setNeedsDisplay]; // not sure if this is needed for none, one, or both.
  return self;
}


DEF_INIT(Frame:(CGRect)frame scene:(id)scene) {
  return [self initWithFrame:frame scene:scene format:QKPixFmtUnknown];
}


- (BOOL)isOpaque {
  return self.layer.opaque;
}


- (void)setupLayer:(CALayer*)layer {
  self.layer = layer;
  self.layer.delegate = self;
  self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
  self.layer.needsDisplayOnBoundsChange = YES;
  self.wantsLayer = YES; // set wantsLayer after layer for layer-hosting view behavior (programmatic layer).
}


- (QKGLLayer *)glLayer {
  return CAST(QKGLLayer, self.layer);
}


// CALayerDelegate method gets called only for CG case.
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  ASSERT_CONFORMS(self.scene, QKCGScene);
  [self.scene drawInCGContext:ctx time:-[_animationStartDate timeIntervalSinceNow] size:self.bounds.size];
}


- (void)setAnimationInterval:(NSTimeInterval)animationInterval {
  
  _animationInterval = animationInterval;
  
  [_timer invalidate];
  
  if (_animationInterval > 0) {
    _animationStartDate = [NSDate date];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval
                                              target:self
                                            selector:@selector(animationTimerFired:)
                                            userInfo:nil
                                             repeats:YES];
  }
  else {
    _animationStartDate = nil;
    _timer = nil;
  }
}


- (void)animationTimerFired:(NSEvent*)event {
  [self setNeedsDisplay];
}


@end
