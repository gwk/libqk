// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "GLView.h"


@interface GLView ()
@end


@implementation GLView


#pragma mark - UIView


+ (Class)layerClass {
  return [GLLayer class];
}


- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  [self setNeedsDisplay]; // necessary? [self.glLayer setNeedsDisplay]?
}


#pragma mark - GLView


PROPERTY_SUBCLASS_ALIAS_RO(GLLayer, glLayer, self.layer);


- (GLCanvasInfo*)canvasInfo {
  return self.glLayer.canvasInfo;
}


- (id)initWithFrame:(CGRect)frame {
  NON_DESIGNATED_INIT(@"initWithFrame:format:scene:");
}


DEF_INIT(Frame:(CGRect)frame format:(QKPixFmt)format scene:(id<GLScene>)scene) {
  INIT(super initWithFrame:frame);
  [self.glLayer setupWithFormat:format scene:scene];
  self.opaque = YES;
  self.contentScaleFactor = [UIScreen mainScreen].scale; // CAEAGLLayer defaults to 1.0 regardless of screen.
  self.contentMode = UIViewContentModeRedraw; // for view resize on orientation change?? ios 5?
  return self;
}


- (V2I32)drawableSize {
  return self.glLayer.drawableSize;
}


- (void)enableContext {
  [self.glLayer enableContext];
}


- (void)disableContext {
  [self.glLayer disableContext];
}


- (void)enableRedisplayWithInterval:(int)interval duringTracking:(BOOL)duringTracking {
  [self.glLayer enableRedisplayWithInterval:interval duringTracking:duringTracking];
}


- (void)disableRedisplay {
  [self.glLayer disableRedisplay];
}


- (void)render {
  [self.glLayer render];
}


@end
