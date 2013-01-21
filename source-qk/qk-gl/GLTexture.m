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
  // forgetting to do appears to result in undefined behavior? (black samples).
  [self setWrap:GL_CLAMP_TO_EDGE];
  [self setFilter:GL_LINEAR];
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
