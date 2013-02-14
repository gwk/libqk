// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKGLView.h"


@interface QKGLView ()

@property (nonatomic) BOOL needsSetup;
@property (nonatomic) GLSceneInfo* sceneInfo;

@end


@implementation QKGLView


#pragma mark - UIView


- (void)drawRect:(CGRect)rect {
  if (_needsSetup) {
    [self.scene setupGLLayer:self.layer time:0 info:_sceneInfo];
    _needsSetup = NO;
  }
  [self.scene drawInGLLayer:self.layer time:0 info:_sceneInfo];
}


- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  [self setNeedsDisplay]; // necessary?
}


#pragma mark - QKGLView


DEF_INIT(Frame:(CGRect)frame format:(QKPixFmt)format scene:(id<GLScene>)scene) {
  EAGLContext* ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!ctx) { // in case host does not support ES2
    assert(0, @"nil EAGLContext"); // debug
    return nil; // for release, just return a nil view
  }
  INIT(super initWithFrame:frame context:ctx);
  _format = format;
  _scene = scene;
  self.needsSetup = YES;
  self.opaque = YES;
  self.contentMode = UIViewContentModeRedraw; // for view resize on orientation change
  // TODO: handle format
  self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
  
  int depth = QKPixFmtDepthSize(_format);
  if (depth > 0) {
    if (depth <= 16) {
      self.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    }
    else {
      self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    }
  }
  int samples = QKPixFmtMultisamples(_format);
  if (samples > 0) {
    self.drawableMultisample = GLKViewDrawableMultisample4X;
  }
  return self;
}


- (void)setScrollBounds:(CGRect)scrollBounds
            contentSize:(CGSize)contentSize
                 insets:(UIEdgeInsets)insets
              zoomScale:(CGFloat)zoomScale {
  
  if (!_sceneInfo) {
    _sceneInfo = [GLSceneInfo new];
  }
  _sceneInfo.contentSize = contentSize;
  _sceneInfo.visibleRect = CGRectMake(scrollBounds.origin.x / contentSize.width,
                                      scrollBounds.origin.y / contentSize.height,
                                      scrollBounds.size.width / contentSize.width,
                                      scrollBounds.size.height / contentSize.height);
  
#if !QK_OPTIMIZE
  if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
    errFL(@"WARNING: QKGLView does not currently consider edge insets when calculating visibleRect");
  }
#endif
  _sceneInfo.zoomScale = zoomScale;
  [self setNeedsDisplay];
}


@end

