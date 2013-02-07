// Copyright 2007-2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLTexture.h"


@implementation GLTexture


- (void)dealloc {
  if (_handle) {
    glDeleteTextures(1, &(_handle)); qkgl_assert();
  }
}


- (id)initWithFormat:(GLenum)format
                size:(V2I32)size
          dataFormat:(GLenum)dataFormat
            dataType:(GLenum)dataType
               bytes:(const void*)bytes {
  
  INIT(super init);
  glGenTextures(1, &_handle); qkgl_assert();
  check(_handle != -1, @"could not generate texture handle");
  _target = GL_TEXTURE_2D; // ES also supports GL_CUBE_MAP
  _format = format;
  _size = size;
  glBindTexture(_target, _handle); qkgl_assert();
  glTexImage2D(_target, 0, _format, _size._[0], _size._[1], 0, dataFormat, dataType, bytes); qkgl_assert();
  // set default wrap and filter for convenience.
  // forgetting to set the filter appears to result in undefined behavior? (black samples).
  [self setWrap:GL_CLAMP_TO_EDGE]; // friendlier for debugging, as it allows vertices to range from 0 to 1.
  [self setFilter:GL_LINEAR]; // choose smooth results over performance as default.
  return self;
}


+ (id)withFormat:(GLenum)format
            size:(V2I32)size
      dataFormat:(GLenum)dataFormat
        dataType:(GLenum)dataType
           bytes:(const void*)bytes {
  
  return [[self alloc] initWithFormat:format
                                 size:size
                           dataFormat:dataFormat
                             dataType:dataType
                                bytes:bytes];
}


+ (id)withFormat:(GLenum)format image:(QKImage*)image {
  return [[self alloc] initWithFormat:format
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


+ (BOOL)bind:(GLTexture*)texture target:(GLenum)target {
  if (texture) {
    assert(target == texture.target, @"target %u does not match texture: %u", target, texture.target);
    [texture bindToTarget];
    return YES;
  }
  else {
    glBindTexture(target, 0);
    return NO;
  }
}


- (GLint) width {
  return _size._[0];
}


- (GLint) height {
  return _size._[1];
}


@end
