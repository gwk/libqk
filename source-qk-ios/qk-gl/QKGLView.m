// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "qk-macros.h"
#import "qk-gl-util.h"
#import "CADisplayLink+QK.h"
#import "QKGLView.h"


Utf8 frameBufferStatusDesc(GLenum status) {
  switch (status) {
      CASE_RET_TOK_SPLIT_UTF8(GL_FRAMEBUFFER_, INCOMPLETE_ATTACHMENT);
      CASE_RET_TOK_SPLIT_UTF8(GL_FRAMEBUFFER_, INCOMPLETE_MISSING_ATTACHMENT);
      CASE_RET_TOK_SPLIT_UTF8(GL_FRAMEBUFFER_, INCOMPLETE_DIMENSIONS);
      CASE_RET_TOK_SPLIT_UTF8(GL_FRAMEBUFFER_, UNSUPPORTED);
    default:
      return "unknown";
  }
}


@interface QKGLView ()

@property (nonatomic) EAGLContext* context;
@property (nonatomic) BOOL needsSetup;
@property (nonatomic) GLCanvasInfo* canvasInfo;

@property (nonatomic) GLuint frameBuffer;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint depthBuffer;

@property (nonatomic, readwrite) CADisplayLink* displayLink;

@end


@implementation QKGLView


#pragma mark - NSObject


- (void) dealloc {
  LOG_METHOD;
  [self enableContext];
  [self destroyBuffers];
  [self disableContext];
}


#pragma mark - UIView


+ (Class)layerClass {
  return [CCAGLLayer class];
}


- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  [self setNeedsDisplay]; // necessary?
}


- (void)layoutSubviews {
  [self updateBuffers];
}


- (void)setNeedsDisplay {
  _displayLink.paused = NO;
}


- (void)setNeedsDisplayInRect:(CGRect)rect {
  _displayLink.paused = NO;
}


#pragma mark - QKGLView


- (id)initWithFrame:(CGRect)frame {
  NON_DESIGNATED_INIT(@"initWithFrame:format:scene:");
}


DEF_INIT(Frame:(CGRect)frame format:(QKPixFmt)format scene:(id<GLScene>)scene) {
  INIT(super initWithFrame:frame);
  _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!_context || ![EAGLContext setCurrentContext:_context]) { // in case host does not support ES2
    qk_assert(0, @"nil EAGLContext"); // debug
    return nil; // for release, just return a nil view
  }
  _format = format;
  _scene = scene;
  _needsSetup = YES;
  self.opaque = YES;
  qk_assert(self.glLayer.opaque, @"glLayer is not opaque");
  self.contentMode = UIViewContentModeRedraw; // for view resize on orientation change
  self.contentScaleFactor = [UIScreen mainScreen].scale; // CAEAGLLayer defaults to 1.0 regardless of screen.
  LOGF(self.contentScaleFactor);
  // TODO: handle format
  self.glLayer.drawableProperties =
  @{
    kEAGLDrawablePropertyRetainedBacking : @(NO), // once the render bufferis presented, its contents may be altered by OpenGL, and therefore must be completely redrawn.
    kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
    };
  return self;
}


PROPERTY_SUBCLASS_ALIAS_RO(CCAGLLayer, glLayer, self.layer);


- (void)enableContext {
  BOOL ok = [EAGLContext setCurrentContext:_context];
  qk_assert(ok, @"could not enable context");
}


- (void)disableContext {
  BOOL ok = [EAGLContext setCurrentContext:nil];
  qk_assert(ok, @"could not disable context");
}


- (void)destroyBuffers {
  glDeleteFramebuffers(1, &_frameBuffer);
  glDeleteRenderbuffers(1, &_renderBuffer);
  glDeleteRenderbuffers(1, &_depthBuffer);
  _frameBuffer = 0;
  _renderBuffer = 0;
  _depthBuffer = 0;
}


- (BOOL)createBuffers {
  // gen
  glGenFramebuffers(1, &_frameBuffer);
  glGenRenderbuffers(1, &_renderBuffer);
  // bind
  glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
  // associate
  BOOL ok = [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
  if (!ok) {
    errFL(@"failed to create render buffer storage");
    qk_assert(0, @"render buffer failure");
    return NO;
  }
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
  // set drawableSize
  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, (&_drawableSize._[0]));
  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, (&_drawableSize._[1]));
  // depth
  int depth = QKPixFmtDepthSize(_format);
  if (depth > 0) {
    GLenum depth_enum = 0;
    if (depth <= 16) {
      depth_enum = GL_DEPTH_COMPONENT16;
    }
    else if (depth <= 24) {
      depth_enum = GL_DEPTH_COMPONENT24_OES;
    }
    else {
      depth_enum = GL_DEPTH_COMPONENT32_OES;
    }
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, depth_enum, _drawableSize._[0], _drawableSize._[1]);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
  }
  // multisampling
  int samples = QKPixFmtMultisamples(_format);
  if (samples > 0) {
    errFL(@"multisampling is not yet implemented.");
    // TODO: http://developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/WorkingwithEAGLContexts/WorkingwithEAGLContexts.html
  }
  // check
  GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
  if (status != GL_FRAMEBUFFER_COMPLETE) {
    errFL(@"failed to make complete framebuffer object: %s (%X); size: %@",
          frameBufferStatusDesc(status), status, V2I32Desc(_drawableSize));
    qk_assert(0, @"framebuffer failure");
    return NO;
  }
  qkgl_check();
  return YES;
}


- (void)updateBuffers {
  [self enableContext];
  [self destroyBuffers];
  [self createBuffers];
}


- (void)setRedisplayInterval:(int)redisplayInterval {
  _redisplayInterval = redisplayInterval;
  _displayLink.frameInterval = MAX(1, redisplayInterval);
  if (redisplayInterval > 0) { // animate
    _displayLink.paused = NO;
  }
}


- (void)enableRedisplayWithInterval:(int)interval duringTracking:(BOOL)duringTracking {
  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
  self.redisplayInterval = interval;
  _displayLink.frameInterval = interval;
  [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                     forMode:(duringTracking ? NSRunLoopCommonModes : NSDefaultRunLoopMode)];
  [self render]; // render immediately so that content always shows up in viewWillAppear animations.
}


- (void)disableRedisplay {
  DISSOLVE(_displayLink);
  _redisplayInterval = 0;
}


- (void)render {
  LOG_METHOD;
  if (_redisplayInterval <= 0) { // no repeat; do not fire again until setNeedsDisplay is called.
    _displayLink.paused = YES;
  }
  if (!_frameBuffer) {
    [self updateBuffers];
  }
  else {
    [self enableContext];
  }
  glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
  glViewport(0, 0, _drawableSize._[0], _drawableSize._[1]);
  qkgl_assert();
  NSTimeInterval time = _displayLink.timestamp; // TODO: this is the timestamp of the last displayed frame
  // for frames after the first, duration is defined, and we should add:
  // + _displayLink.frameInterval + _displayLink.duration; // TODO: verify that this is correct.
  if (_needsSetup) {
    [_scene setupGLLayer:self.glLayer time:time info:_canvasInfo]; qkgl_assert();
    _needsSetup = NO;
  }
  [_scene drawInGLLayer:self.glLayer time:time info:_canvasInfo]; qkgl_assert();
  glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer); qkgl_assert();
  BOOL ok = [_context presentRenderbuffer:GL_RENDERBUFFER];
  qk_assert(ok, @"presentRenderbuffer failed");
  qkgl_assert();
}


- (void)setScrollBounds:(CGRect)scrollBounds
            contentSize:(CGSize)contentSize
                 insets:(UIEdgeInsets)insets
              zoomScale:(CGFloat)zoomScale {
  
  if (!_canvasInfo) {
    _canvasInfo = [GLCanvasInfo new];
  }
  _canvasInfo.size = contentSize;
  _canvasInfo.visibleRect = CGRectMake(scrollBounds.origin.x / contentSize.width,
                                       scrollBounds.origin.y / contentSize.height,
                                       scrollBounds.size.width / contentSize.width,
                                       scrollBounds.size.height / contentSize.height);
  
#if !QK_OPTIMIZE
  if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
    errFL(@"WARNING: QKGLView does not currently consider edge insets when calculating visibleRect");
  }
#endif
  _canvasInfo.zoomScale = zoomScale;
  [self setNeedsDisplay];
}


@end

