// Copyright 2007-2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-log.h"
#import "qk-gl-util.h"
#import "GLTexture.h"


static GLint maxTextureSize = 0;

@implementation GLTexture


- (void)dissolve {
  glDeleteTextures(1, &(_handle)); qkgl_assert();
  _handle = 0;
}


DEF_INIT(Format:(GLenum)format      // e.g. GL_RGBA
         size:(V2I32)size
         dataFormat:(GLenum)dataFormat // e.g. GL_RGBA
         dataType:(GLenum)dataType   // e.g. GL_FLOAT
         bytes:(const void*)bytes) {
  
  // check texture size
  if (!maxTextureSize) {
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize); // should be at least 2048
    errFL(@"GLTexture maxTextureSize: %d", maxTextureSize);
  }
  if (size.v[0] > maxTextureSize || size.v[1] > maxTextureSize) {
    errFL(@"GLTexture received oversized texture: %@", V2I32Desc(size));
    qk_assert(0, @"bad texture"); // for release pass through busted texture.
    size.v[0] = maxTextureSize;
    size.v[1] = maxTextureSize;
  }
  INIT(super init);
  glGenTextures(1, &_handle); qkgl_assert();
  qk_check(_handle != -1, @"could not generate texture handle");
  _target = GL_TEXTURE_2D; // ES also supports GL_CUBE_MAP
  _format = format;
  _size = size;
  glBindTexture(_target, _handle); qkgl_assert();
  glTexImage2D(_target, 0, _format, _size.v[0], _size.v[1], 0, dataFormat, dataType, bytes); qkgl_assert();
  // set default wrap and filter for convenience.
  // forgetting to set the filter appears to result in undefined behavior? (black samples).
  [self setWrap:GL_CLAMP_TO_EDGE]; // friendlier for debugging, as it allows vertices to range from 0 to 1.
  [self setFilter:GL_LINEAR]; // choose smooth results over performance as default.
  return self;
}


DEF_INIT(Format:(GLenum)format image:(QKImage*)image) {
  return [self initWithFormat:format
                         size:image.size
                   dataFormat:image.glDataFormat
                     dataType:image.glDataType
                        bytes:image.bytes];
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
    default: qk_fail(@"bad texture filter parameter: %d", filter);
  }
  glTexParameteri(_target, GL_TEXTURE_MIN_FILTER, filter); qkgl_assert();
}


- (void)setMagFilter:(GLenum)filter {
  [self bindToTarget]; // does texture need to be bound when this is called?
  switch (filter) {
    case GL_NEAREST:
    case GL_LINEAR:
      break;
    default: qk_fail(@"bad texture filter parameter: %d", filter);
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
    default: qk_fail(@"bad texture wrap parameter: %d", wrap);
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


+ (BOOL)bind:(GLTexture*)texture target:(GLenum)target {
  if (texture) {
    qk_assert(target == texture.target, @"target %u does not match texture: %u", target, texture.target);
    [texture bindToTarget];
    return YES;
  }
  else {
    glBindTexture(target, 0);
    return NO;
  }
}


- (GLint) width {
  return _size.v[0];
}


- (GLint) height {
  return _size.v[1];
}


@end
