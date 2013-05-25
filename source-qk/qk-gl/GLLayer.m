// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_IPHONE
#import <OpenGLES/EAGLDrawable.h>
#import "CADisplayLink+QK.h"
#else // mac
#endif


#import "qk-macros.h"
#import "qk-gl-util.h"
#import "QKMutableStructArray.h"
#import "QKPixFmt.h"
#import "GLLayer.h"


@interface GLLayer ()

@property (nonatomic) BOOL needsSetup;

#if TARGET_OS_IPHONE
@property (nonatomic) EAGLContext* context;
@property (nonatomic) GLuint frameBuffer;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint depthBuffer;
@property (nonatomic, readwrite) CADisplayLink* displayLink;
#else // mac
#endif

@end



@implementation GLLayer


#pragma mark - cross


#pragma mark - CALayer


- (void)setContentsScale:(CGFloat)contentsScale {
  [super setContentsScale:CLAMP(contentsScale, 1, _maxContentsScale)]; // prevent contents scale approaching zero.
}


#pragma mark - GLLayer


DEF_INIT(Format:(QKPixFmt)format scene:(id<GLScene>)scene) {
  INIT(super init);
  [self setupWithFormat:format scene:scene];
  return self;
}


- (void)setMaxContentsScale:(CGFloat)maxContentsScale {
  _maxContentsScale = maxContentsScale;
  self.contentsScale = self.contentsScale;
}


#if TARGET_OS_IPHONE
#pragma mark - ios


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


#pragma mark - NSObject


- (void) dealloc {
  LOG_METHOD;
  [self enableContext];
  [self destroyBuffers];
  [self disableContext];
}


#pragma mark - CALayer


+ (BOOL)needsDisplayForKey:(NSString*)key {
  // needsDisplayOnBoundsChange is not effective, presumable because display never gets called, or setNeedsDisplay does not get called.
  // checking for the bounds key does cause setNeedsDisplay to be called though, which we override to trigger render.
  if ([key isEqualToString:@"bounds"]) {
    return YES;
  }
  return [super needsDisplayForKey:key];
}


- (void)layoutSublayers {
  [self updateBuffers];
}


- (void)setNeedsDisplay {
  _displayLink.paused = NO;
}


- (void)setNeedsDisplayInRect:(CGRect)rect {
  _displayLink.paused = NO;
}


#pragma mark - GLLayer


- (BOOL)setupWithFormat:(QKPixFmt)format scene:(id<GLScene>)scene {
  _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!_context || ![EAGLContext setCurrentContext:_context]) { // in case host does not support ES2
    qk_assert(0, @"nil EAGLContext"); // debug
    return NO;
  }
  _format = format;
  _scene = scene;
  _needsSetup = YES;
  _canvasInfo = [GLCanvasInfo new];
  _maxContentsScale = 2;
  //self.opaque = YES;
  // TODO: handle format
  self.opaque = YES;
  self.opacity = 1;
  self.asynchronous = NO;
  self.drawableProperties =
  @{
    kEAGLDrawablePropertyRetainedBacking : @(NO), // once the render buffer is presented, its contents may be altered by OpenGL, and therefore must be completely redrawn.
    kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
    };
  return YES;
}


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
  glGenFramebuffers(1, &_frameBuffer); qkgl_assert();
  glGenRenderbuffers(1, &_renderBuffer); qkgl_assert();
  // bind
  glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer); qkgl_assert();
  glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer); qkgl_assert();
  // associate
  BOOL ok = [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
  if (!ok) {
    errFL(@"failed to create render buffer storage; contentsScale: %f", self.contentsScale);
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
  if (!_scene) {
    return;
  }
  if (_redisplayInterval <= 0) { // no repeat; do not fire again until setNeedsDisplay is called.
    _displayLink.paused = YES;
  }
  if (!_frameBuffer) {
    // should early exit happen here?
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
    [_scene setupGLLayer:self time:time info:_canvasInfo]; qkgl_assert();
    _needsSetup = NO;
  }
  [_scene drawInGLLayer:self time:time info:_canvasInfo]; qkgl_assert();
  glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer); qkgl_assert();
  BOOL ok = [_context presentRenderbuffer:GL_RENDERBUFFER];
  qk_assert(ok, @"presentRenderbuffer failed");
  qkgl_assert();
}


- (void)trackScrollBounds:(CGRect)scrollBounds
              contentSize:(CGSize)contentSize
                   insets:(UIEdgeInsets)insets
                zoomScale:(CGFloat)zoomScale {
  
  _canvasInfo.size = contentSize;
  _canvasInfo.visibleRect = CGRectMake(scrollBounds.origin.x / contentSize.width,
                                       scrollBounds.origin.y / contentSize.height,
                                       scrollBounds.size.width / contentSize.width,
                                       scrollBounds.size.height / contentSize.height);
#if !QK_OPTIMIZE
  if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
    errFL(@"WARNING: GLLayer does not currently consider edge insets when calculating visibleRect");
  }
#endif
  _canvasInfo.zoomScale = zoomScale;
  [self setNeedsDisplay];
}


#else
#pragma mark - mac


void describePFA(CGLPixelFormatObj format, GLint virtualScreen, CGLPixelFormatAttribute attribute, char *name) {
  GLint val;
  
  CGLError e = CGLDescribePixelFormat(format, virtualScreen, attribute, &val);
  if (e) {
    errFL(@"  %s:\tERROR: %d", name, e);
  }
  else {
    errFL(@"  %s:\t%d", name, val);
  }
}


#define descPFA(format, virtualScreen, attribute) describePFA(format, virtualScreen, attribute, #attribute)

void describeAllPFA(CGLPixelFormatObj format, GLint virtualScreen) {
  errFL(@"pixel format %p", format);
  descPFA(format, virtualScreen, kCGLPFAAccelerated);
  descPFA(format, virtualScreen, kCGLPFAAcceleratedCompute);
  descPFA(format, virtualScreen, kCGLPFAAccumSize);
  descPFA(format, virtualScreen, kCGLPFAAllRenderers);
  descPFA(format, virtualScreen, kCGLPFAAllowOfflineRenderers);
  descPFA(format, virtualScreen, kCGLPFAAlphaSize);
  descPFA(format, virtualScreen, kCGLPFAAuxBuffers);
  descPFA(format, virtualScreen, kCGLPFAAuxDepthStencil);
  descPFA(format, virtualScreen, kCGLPFABackingStore);
  descPFA(format, virtualScreen, kCGLPFAClosestPolicy);
  descPFA(format, virtualScreen, kCGLPFAColorFloat);
  descPFA(format, virtualScreen, kCGLPFAColorSize);
  descPFA(format, virtualScreen, kCGLPFACompliant);
  descPFA(format, virtualScreen, kCGLPFADepthSize);
  descPFA(format, virtualScreen, kCGLPFADisplayMask);
  descPFA(format, virtualScreen, kCGLPFADoubleBuffer);
  descPFA(format, virtualScreen, kCGLPFAFullScreen);
  descPFA(format, virtualScreen, kCGLPFAMPSafe);
  descPFA(format, virtualScreen, kCGLPFAMaximumPolicy);
  descPFA(format, virtualScreen, kCGLPFAMinimumPolicy);
  descPFA(format, virtualScreen, kCGLPFAMultiScreen);
  descPFA(format, virtualScreen, kCGLPFAMultisample);
  descPFA(format, virtualScreen, kCGLPFANoRecovery);
  descPFA(format, virtualScreen, kCGLPFAOffScreen);
  descPFA(format, virtualScreen, kCGLPFAOpenGLProfile);
  descPFA(format, virtualScreen, kCGLPFAPBuffer);
  descPFA(format, virtualScreen, kCGLPFARemotePBuffer);
  descPFA(format, virtualScreen, kCGLPFARendererID);
  descPFA(format, virtualScreen, kCGLPFARobust);
  descPFA(format, virtualScreen, kCGLPFASampleAlpha);
  descPFA(format, virtualScreen, kCGLPFASampleBuffers);
  descPFA(format, virtualScreen, kCGLPFASamples);
  descPFA(format, virtualScreen, kCGLPFASingleRenderer);
  descPFA(format, virtualScreen, kCGLPFAStencilSize);
  descPFA(format, virtualScreen, kCGLPFAStereo);
  descPFA(format, virtualScreen, kCGLPFASupersample);
  descPFA(format, virtualScreen, kCGLPFAVirtualScreenCount);
  descPFA(format, virtualScreen, kCGLPFAWindow);
  errL(@"");
}


- (CGLPixelFormatObj)copyCGLPixelFormatForDisplayMask:(uint32_t)mask {
  
  QKMutableStructArray* attributes = [QKMutableStructArray withElSize:sizeof(CGLPixelFormatAttribute)];
  [attributes appendI32:kCGLPFADoubleBuffer];
  
  [attributes appendI32:kCGLPFAColorSize];
  [attributes appendI32:QKPixFmtColorSize(_format)];
  [attributes appendI32:kCGLPFAAlphaSize];
  [attributes appendI32:QKPixFmtAlphaSize(_format)];
  [attributes appendI32:kCGLPFADepthSize];
  [attributes appendI32:QKPixFmtDepthSize(_format)];
  if (_format & QKPixFmtBitF32) {
    [attributes appendI32:kCGLPFAColorFloat];
  }
  int samples = QKPixFmtMultisamples(_format);
  if (samples) {
    [attributes appendI32:kCGLPFAMultisample];
    [attributes appendI32:kCGLPFASamples];
    [attributes appendI32:samples];
    //kCGLPFASampleAlpha?
  }
  //kCGLPFAAcceleratedCompute,
  [attributes appendI32:0]; // null terminator
  
  CGLPixelFormatObj pixelFormat;
  GLint virtualScreenCount;
  
  CGLError e = CGLChoosePixelFormat(attributes.bytes, &pixelFormat, &virtualScreenCount);
  
  if (e) {
    errFL(@"CGL error creating pixel format (will fall back): %d", e);
    return [super copyCGLPixelFormatForDisplayMask:mask];
  }
  
  //describeAllPFA(pixelFormat, 0);
  return pixelFormat;
}


- (CGLContextObj)copyCGLContextForPixelFormat:(CGLPixelFormatObj)pixelFormat {
  _needsSetup = YES;
  CGLContextObj ctx = [super copyCGLContextForPixelFormat:pixelFormat];
  return ctx;
}


- (BOOL)canDrawInCGLContext:(CGLContextObj)ctx
                pixelFormat:(CGLPixelFormatObj)pixelFormat
               forLayerTime:(CFTimeInterval)layerTime
                displayTime:(const CVTimeStamp *)displayTime {
  return YES;
}


- (void)drawInCGLContext:(CGLContextObj)ctx
             pixelFormat:(CGLPixelFormatObj)pixelFormat
            forLayerTime:(CFTimeInterval)layerTime
             displayTime:(const CVTimeStamp *)displayTime {
  
  ASSERT_CONFORMS(self.scene, GLScene);
  CGLSetCurrentContext(ctx);
  if (!_canvasInfo) {
    _canvasInfo = [GLCanvasInfo new];
  }
  _canvasInfo.size = self.bounds.size;
  _canvasInfo.visibleRect = CGRectMake(0, 0, 1, 1);
  if (_needsSetup) {
    [self.scene setupGLLayer:self time:layerTime info:_canvasInfo];
    _needsSetup = NO;
  }
  [self.scene drawInGLLayer:self time:layerTime info:_canvasInfo];
  CGLSetCurrentContext(NULL);
  // according to the header comments, we should call super to flush correctly.
  [super drawInCGLContext:ctx pixelFormat:pixelFormat forLayerTime:layerTime displayTime:displayTime]; // calls flush
}

#endif // TARGET_OS_IPHONE


@end
