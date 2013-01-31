// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "QKGLLayer.h"


@interface QKGLLayer ()

@property (nonatomic) BOOL needsSetup;

@end



@implementation QKGLLayer


- (void)setContentsScale:(CGFloat)contentsScale {
  [super setContentsScale:MIN(contentsScale, _maxContentScale)];
}


- (void)setMaxContentScale:(CGFloat)maxContentScale {
  _maxContentScale = maxContentScale;
  self.contentsScale = self.contentsScale;
}


- (id)initWithFormat:(QKPixFmt)format renderer:(id<QKGLRenderer>)renderer {
  INIT(super init);
  _format = format;
  _renderer = renderer;
  return self;
}


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
  descPFA(format, virtualScreen, kCGLPFAAllRenderers);
  descPFA(format, virtualScreen, kCGLPFADoubleBuffer);
  descPFA(format, virtualScreen, kCGLPFAStereo);
  descPFA(format, virtualScreen, kCGLPFAAuxBuffers);
  descPFA(format, virtualScreen, kCGLPFAColorSize);
  descPFA(format, virtualScreen, kCGLPFAAlphaSize);
  descPFA(format, virtualScreen, kCGLPFADepthSize);
  descPFA(format, virtualScreen, kCGLPFAStencilSize);
  descPFA(format, virtualScreen, kCGLPFAAccumSize);
  descPFA(format, virtualScreen, kCGLPFAMinimumPolicy);
  descPFA(format, virtualScreen, kCGLPFAMaximumPolicy);
  descPFA(format, virtualScreen, kCGLPFAOffScreen);
  descPFA(format, virtualScreen, kCGLPFAFullScreen);
  descPFA(format, virtualScreen, kCGLPFASampleBuffers);
  descPFA(format, virtualScreen, kCGLPFASamples);
  descPFA(format, virtualScreen, kCGLPFAAuxDepthStencil);
  descPFA(format, virtualScreen, kCGLPFAColorFloat);
  descPFA(format, virtualScreen, kCGLPFAMultisample);
  descPFA(format, virtualScreen, kCGLPFASupersample);
  descPFA(format, virtualScreen, kCGLPFASampleAlpha);
  descPFA(format, virtualScreen, kCGLPFARendererID);
  descPFA(format, virtualScreen, kCGLPFASingleRenderer);
  descPFA(format, virtualScreen, kCGLPFANoRecovery);
  descPFA(format, virtualScreen, kCGLPFAAccelerated);
  descPFA(format, virtualScreen, kCGLPFAClosestPolicy);
  descPFA(format, virtualScreen, kCGLPFARobust);
  descPFA(format, virtualScreen, kCGLPFABackingStore);
  descPFA(format, virtualScreen, kCGLPFAMPSafe);
  descPFA(format, virtualScreen, kCGLPFAWindow);
  descPFA(format, virtualScreen, kCGLPFAMultiScreen);
  descPFA(format, virtualScreen, kCGLPFACompliant);
  descPFA(format, virtualScreen, kCGLPFADisplayMask);
  descPFA(format, virtualScreen, kCGLPFAPBuffer);
  descPFA(format, virtualScreen, kCGLPFARemotePBuffer);
  descPFA(format, virtualScreen, kCGLPFAAllowOfflineRenderers);
  descPFA(format, virtualScreen, kCGLPFAAcceleratedCompute);
  descPFA(format, virtualScreen, kCGLPFAOpenGLProfile);
  descPFA(format, virtualScreen, kCGLPFAVirtualScreenCount);
  errL(@"");
}



- (CGLPixelFormatObj)copyCGLPixelFormatForDisplayMask:(uint32_t)mask {
  
  QKMutableStructArray* attributes = [QKMutableStructArray withElSize:sizeof(CGLPixelFormatAttribute)];
  [attributes appendI32:kCGLPFADoubleBuffer];
  int depth = QKPixFmtDepth(_format);
  if (depth) {
    [attributes appendI32:kCGLPFADepthSize];
    [attributes appendI32:depth];
  }
  int samples = QKPixFmtMultisamples(_format);
  if (samples) {
    [attributes appendI32:kCGLPFAMultisample];
    [attributes appendI32:samples];
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
  CGLContextObj ctx = [super copyCGLContextForPixelFormat:pixelFormat];
  _needsSetup = YES;
  return ctx;
}


- (void)drawInCGLContext:(CGLContextObj)ctx
             pixelFormat:(CGLPixelFormatObj)pixelFormat
            forLayerTime:(CFTimeInterval)layerTime
             displayTime:(const CVTimeStamp *)displayTime {
  
  CGLSetCurrentContext(ctx);
  CGSize s = self.bounds.size;
  if (_needsSetup) {
    [self.renderer setupCGLContext:ctx time:layerTime];
    _needsSetup = NO;
  }
  [self.renderer drawInCGLContext:ctx time:layerTime size:s];
  CGLSetCurrentContext(NULL);
}

@end
