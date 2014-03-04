// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#if TARGET_OS_IPHONE
#import <OpenGLES/ES2/gl.h>
#else
#define GL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
#import <OpenGL/glu.h>
#endif


#import "NSString+QK.h"
#import "qk-macros.h"
#import "qk-check.h"
#import "qk-gl-util.h"


#pragma mark - shaders


void qkgl_set_shader_source(GLuint handle, Ascii source) {
  glShaderSource(handle, 1, &source, NULL); qkgl_assert();
}


GLint qkgl_get_shader_param(GLuint handle, GLenum param_name) {
  GLint param = 0; // returned if error occurs
  glGetShaderiv(handle, param_name, &param); qkgl_assert();
  return param;
}


NSString* qkgl_get_shader_info_log(GLuint handle) {
  int len = qkgl_get_shader_param(handle, GL_INFO_LOG_LENGTH);
  GLchar info[len];
  glGetShaderInfoLog(handle, len, NULL, info); qkgl_assert();
  return [NSString withUtf8:info];
}


#pragma mark - programs


GLint qkgl_get_program_param(GLuint handle, GLenum param_name) {
  GLint param = 0; // returned if error occurs
  glGetProgramiv(handle, param_name, &param); qkgl_assert();
  return param;
}


NSString* qkgl_get_program_info_log(GLuint handle) {
  int len = qkgl_get_program_param(handle, GL_INFO_LOG_LENGTH);
  GLchar info[len];
  glGetProgramInfoLog(handle, len, NULL, info); qkgl_assert();
  return [NSString withUtf8:info];
}


#pragma mark - utilities


int qkgl_max_vertex_attributes() {
  int val;
  glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &val);
  return val;
}


NSString* qkgl_error_string(GLenum error_code) {
#if TARGET_OS_IPHONE
  switch (error_code) {
      CASE_RET_TOK_STR(GL_INVALID_ENUM);
      CASE_RET_TOK_STR(GL_INVALID_VALUE);
      CASE_RET_TOK_STR(GL_INVALID_OPERATION);
      CASE_RET_TOK_STR(GL_OUT_OF_MEMORY);
      CASE_RET_TOK_STR(GL_NO_ERROR);
    default:
      return [NSString stringWithFormat:@"UNKNOWN: 0x%X", error_code];
  }
#else
  return [NSString withUtf8:(Utf8)gluErrorString(error_code)];
#endif
}


void qkgl_check() {
  GLenum code = glGetError();
  if (code == GL_NO_ERROR) {
    return;
  }
  // OpenGL spec says multiple errors may be set, and that we should always get them all.
  NSMutableString* s = [NSMutableString new];
  while (code) {
    [s appendFormat:@" %@", qkgl_error_string(code)];
    code = glGetError();
  }
  qk_fail(@"OpenGL: %s", s.UTF8String);
}


#pragma mark - viewport


V2F32 viewportOriginLetterboxed(V2F32 origin, F32 contentAR, F32 canvasAR) {
  if (contentAR <= 0 || canvasAR <= 0) {
    return origin;
  }
  F32 ar = contentAR / canvasAR;
  if (ar > 1) { // content is wide compared to canvas; letterbox y
    return V2F32Make(origin.v[0], origin.v[1] + (1 - ar) * .5);
  }
  else { // content is narrow; letterbox x
    return V2F32Make(origin.v[0] + (1 - (1 / ar)) * .5, origin.v[1]);
  }
}


V2F32 viewportScaleLetterboxed(V2F32 scale, F32 contentAR, F32 canvasAR) {
  if (contentAR <= 0 || canvasAR <= 0) {
    return scale;
  }
  F32 ar = contentAR / canvasAR;
  if (ar > 1) { // content is wide compared to canvas; letterbox y
    return V2F32Make(scale.v[0], scale.v[1] / ar);
  }
  else { // content is narrow; letterbox x
    return V2F32Make(scale.v[0] * ar, scale.v[1]);
  }
}




