// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "QKView.h"


@interface QKView ()

@property (nonatomic, weak, readwrite) id renderer; // QKGLRenderer or QKCGRenderer
@property (nonatomic) NSTimer* timer;
@property (nonatomic) NSDate*  animationStartDate;

@end


@implementation QKView


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %@ %@>",
          self.class, self, NSStringFromCGRect(self.frame), self.layer];
}


- (id)initWithFrame:(CGRect)frame {
  NON_DESIGNATED_INIT(@"initWithFrame:renderer:glFormat:");
}


- (id)initWithFrame:(CGRect)frame renderer:(id)renderer glFormat:(QKPixFmt)glFormat {
  INIT(super initWithFrame:frame);
  self.renderer = renderer;
  if (glFormat) {
    [self setupLayer:[[QKGLLayer alloc] initWithFormat:glFormat renderer:renderer]];
  }
  else {
    [self setupLayer:[CALayer new]];
  }
  self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawBeforeViewResize;
  //[self.layer setNeedsDisplay]; // not sure if this is needed for none, one, or both.
  return self;
}


- (BOOL)isOpaque {
  return self.layer.opaque;
}


- (id)initWithFrame:(CGRect)frame renderer:(id)renderer {
  return [self initWithFrame:frame renderer:renderer glFormat:QKPixFmtUnknown];
}


+ (id)withFrame:(CGRect)frame renderer:(id)renderer glFormat:(QKPixFmt)glFormat {
  return [[self alloc] initWithFrame:frame renderer:renderer glFormat:glFormat];
}


+ (id)withFrame:(CGRect)frame renderer:(id)renderer {
  return [[self alloc] initWithFrame:frame renderer:renderer];
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
  ASSERT_CONFORMS(self.renderer, QKCGRenderer);
  [self.renderer drawInCGContext:ctx time:-[_animationStartDate timeIntervalSinceNow] size:self.bounds.size];
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
  [self setNeedsDisplay:YES];
}


@end
