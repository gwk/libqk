// Copyright 2007-2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLTexture.h"


@implementation GLTexture


- (void)dealloc {
  if (_handle) {
    glDeleteTextures(1, &(_handle));
  }
}


- (id)initWithTarget:(GLenum)target
              format:(GLenum)format
                size:(V2I32)size
          dataFormat:(GLenum)dataFormat
            dataType:(GLenum)dataType
               bytes:(void*)bytes {
  
  INIT(super init);
  glGenTextures(1, &_handle); qkgl_assert();
  check(_handle != -1, @"could not generate texture handle");
  _target = target;
  _format = format;
  _size = size;
  glBindTexture(_target, _handle); qkgl_assert();
  glTexImage2D(_target, 0, _format, _size._[0], _size._[1], 0, dataFormat, dataType, bytes); qkgl_assert();
  // set default wrap and filter for convenience.
  // forgetting to set the filter appears to result in undefined behavior? (black samples).
  [self setWrap:GL_CLAMP_TO_EDGE]; // probably friendlier for debugging, as it allows vertices to range from 0 to 1.
  [self setFilter:GL_LINEAR]; // choose better results over performance as default.
  return self;
}


+ (id)withTarget:(GLenum)target
          format:(GLenum)format
            size:(V2I32)size
      dataFormat:(GLenum)dataFormat
        dataType:(GLenum)dataType
           bytes:(void*)bytes {
  
  return [[self alloc] initWithTarget:target
                               format:format
                                 size:size
                           dataFormat:dataFormat
                             dataType:dataType
                                bytes:bytes];
}


/* From Quartz 2D Programming Guide: Graphics Contexts
 ColorSpace, Bits per pixel, Bytes per component, Flags
 Null -   8 bpp,  8 bpc, kCGImageAlphaOnly - Mac OS X, iOS
 Gray -   8 bpp,  8 bpc, kCGImageAlphaNone - Mac OS X, iOS
 Gray -   8 bpp,  8 bpc, kCGImageAlphaOnly - Mac OS X, iOS
 Gray -  16 bpp, 16 bpc, kCGImageAlphaNone - Mac OS X
 Gray -  32 bpp, 32 bpc, kCGImageAlphaNone|kCGBitmapFloatComponents - Mac OS X
 RGB  -  16 bpp,  5 bpc, kCGImageAlphaNoneSkipFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaNoneSkipFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaNoneSkipLast - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaPremultipliedFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaPremultipliedLast - Mac OS X, iOS
 RGB  -  64 bpp, 16 bpc, kCGImageAlphaPremultipliedLast - Mac OS X
 RGB  -  64 bpp, 16 bpc, kCGImageAlphaNoneSkipLast - Mac OS X
 RGB  - 128 bpp, 32 bpc, kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents - Mac OS X
 RGB  - 128 bpp, 32 bpc, kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents - Mac OS X
 CMYK -  32 bpp,  8 bpc, kCGImageAlphaNone - Mac OS X
 CMYK -  64 bpp, 16 bpc, kCGImageAlphaNone - Mac OS X
 CMYK - 128 bpp, 32 bpc, kCGImageAlphaNone|kCGBitmapFloatComponents - Mac OS X
*/

+ (id)withFormat:(GLenum)format CGImage:(CGImageRef)image {
  assert(image, @"NULL image");
  V2I32 size = V2I32Make(CGImageGetWidth(image), CGImageGetHeight(image));
  int comps;
  CGColorSpaceRef space;
  CGBitmapInfo info;
  GLenum dataFormat;
  switch (format) {
    case GL_RGB:
      comps = 4;
      space = CGColorSpaceCreateDeviceRGB();
      info = kCGImageAlphaNoneSkipLast;
      dataFormat = GL_RGB;
      break;
    case GL_RGBA:
      comps = 4;
      space = CGColorSpaceCreateDeviceRGB();
      info = kCGImageAlphaPremultipliedLast;
      dataFormat = GL_RGBA;
      break;
    default:
      fail(@"bad format: 0x%X", format);
  }
  F64 t = [NSDate refTime];
  CGContextRef ctx = CGBitmapContextCreate(NULL, size._[0], size._[1], 8, size._[0] * comps, space, info);
  check(ctx, @"could not create context for gl format: 0x%X; comps: %d;", format, comps);
  // flip y
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -size._[1]);
  CGContextDrawImage(ctx, CGRectMake(0, 0, size._[0], size._[1]), image);
  void* bytes = CGBitmapContextGetData(ctx);
  LOG_TIME_INTERVAL(t, @"CG");
  switch (dataFormat) {
    case GL_RGB: { // remove alpha bytes, which CG skipped over; we can do this in place because ctx is done rendering.
      V4U8* from = bytes;
      V3U8* to = bytes;
      V4U8* end = bytes + size._[0] * size._[1] * sizeof(V4U8);
      while (from < end) {
        *to = *((V3U8*)from);
        to++;
        from++;
      }
      break;
    }
  }
  LOG_TIME_INTERVAL(t, @"remove alpha");
  id texture =
  [self withTarget:GL_TEXTURE_2D format:format size:size dataFormat:dataFormat dataType:GL_UNSIGNED_BYTE bytes:bytes];
  LOG_TIME_INTERVAL(t, @"GL");
  CGContextRelease(ctx);
  return texture;
}


- (void)setMinFilter:(GLenum)filter {
  [self bindToTarget]; // does texture need to be bound when this is called?
  switch (filter) {
    case GL_NEAREST:
    case GL_LINEAR:
    case GL_NEAREST_MIPMAP_NEAREST:
    case GL_LINEAR_MIPMAP_NEAREST:
    case GL_NEAREST_MIPMAP_LINEAR:
    case GL_LINEAR_MIPMAP_LINEAR:
      break;
    default: fail(@"bad texture filter parameter: %d", filter);
  }
  glTexParameteri(_target, GL_TEXTURE_MIN_FILTER, filter); qkgl_assert();
}


- (void)setMagFilter:(GLenum)filter {
  [self bindToTarget]; // does texture need to be bound when this is called?
  switch (filter) {
    case GL_NEAREST:
    case GL_LINEAR:
      break;
    default: fail(@"bad texture filter parameter: %d", filter);
  }
  glTexParameteri(_target, GL_TEXTURE_MAG_FILTER, filter); qkgl_assert();
}


- (void)setFilter:(GLenum)filter {
  [self setMinFilter:filter];
  GLenum mag_filter = (filter == GL_NEAREST || filter == GL_NEAREST_MIPMAP_NEAREST) ? GL_NEAREST : GL_LINEAR;
  [self setMagFilter:mag_filter];
}


- (void)setWrap:(GLenum)wrap parameter:(GLenum)parameter {
  [self bindToTarget]; // does texture need to be bound when this is called?
  switch (wrap) {
    case GL_CLAMP_TO_EDGE:
    case GL_MIRRORED_REPEAT:
    case GL_REPEAT:
      break;
    default: fail(@"bad texture wrap parameter: %d", wrap);
  }
  glTexParameteri(_target, parameter, wrap); qkgl_assert();
  glTexParameteri(_target, parameter, wrap); qkgl_assert();
}


- (void)setWrap:(GLenum)wrap {
  [self setWrap:wrap parameter:GL_TEXTURE_WRAP_S];
  [self setWrap:wrap parameter:GL_TEXTURE_WRAP_T];
}


- (void)bindToTarget {
  //glEnable(_target); qkgl_assert(); // necessary in OpenGL? invalid in ES2
  glBindTexture(_target, _handle); qkgl_assert();
}


- (void)unbindFromTarget {
  //glEnable(_target); qkgl_assert(); // necessary in OpenGL? invalid in ES2
  glBindTexture(_target, 0); qkgl_assert();
}


- (GLint) width {
  return _size._[0];
}


- (GLint) height {
  return _size._[1];
}


@end
