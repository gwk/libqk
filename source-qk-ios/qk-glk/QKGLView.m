// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKGLView.h"


@interface QKGLView ()
@property (nonatomic) BOOL needsSetup;
@end


@implementation QKGLView



- (void)drawRect:(CGRect)rect {
  EAGLContext* ctx = self.context;
  CGSize size = self.bounds.size;
  CGFloat scale = self.contentScaleFactor;
  if (_needsSetup) {
    [self.scene setupGLContext:ctx time:0 size:size scale:scale];
    _needsSetup = NO;
  }
  [self.scene drawInGLContext:ctx time:0 size:size scale:scale];
}


- (id)initWithFrame:(CGRect)frame scene:(id<GLScene>)scene format:(QKPixFmt)format {
  EAGLContext* ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!ctx) { // in case host does not support ES2
    assert(0, @"nil EAGLContext"); // debug
    return nil; // for release, just return a nil view
  }
  INIT(super initWithFrame:frame context:ctx);
  _scene = scene;
  _format = format;
  self.needsSetup = YES;
  self.opaque = YES;
  self.contentMode = UIViewContentModeRedraw; // for view resize on orientation change
  // TODO: handle format
  self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
  self.drawableDepthFormat = GLKViewDrawableDepthFormat16;
  self.drawableMultisample = GLKViewDrawableMultisampleNone;
  return self;
}


+ (id)withFrame:(CGRect)frame scene:(id)scene format:(QKPixFmt)format {
  return [[self alloc] initWithFrame:frame scene:scene format:format];
}


@end

