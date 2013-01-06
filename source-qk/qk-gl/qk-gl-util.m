// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"
#import "qk-gl-util.h"


#pragma mark - shaders


void qkgl_set_shader_source(GLuint handle, Ascii source) {
  glShaderSource(handle, 1, &source, NULL);
  qkgl_assert();
}


GLint qkgl_get_shader_param(GLuint handle, GLenum param_name) {
  GLint param = 0; // returned if error occurs
  glGetShaderiv(handle, param_name, &param);
  qkgl_assert();
  return param;
}


NSString* qkgl_get_shader_info_log(GLuint handle) {
  int len = qkgl_get_shader_param(handle, GL_INFO_LOG_LENGTH);
  GLchar info[len];
  glGetShaderInfoLog(handle, len, NULL, info);
  qkgl_assert();
  return [NSString withUtf8:info];
}


#pragma mark - programs


GLint qkgl_get_program_param(GLuint handle, GLenum param_name) {
  GLint param = 0; // returned if error occurs
  glGetProgramiv(handle, param_name, &param);
  qkgl_assert();
  return param;
}


NSString* qkgl_get_program_info_log(GLuint handle) {
  int len = qkgl_get_program_param(handle, GL_INFO_LOG_LENGTH);
  GLchar info[len];
  glGetProgramInfoLog(handle, len, NULL, info);
  qkgl_assert();
  return [NSString withUtf8:info];
}


#pragma mark - utilities


NSString* qkgl_error_string(GLenum error_code) {
#if TARGET_OS_IPHONE
  switch (error_code) {
      CASE_RETURN_TOKEN(GL_NO_ERROR);
    default:
      return [NSString stringWithFormat:@"UNKNOWN:0x%X", error_code];
  }
#else
  return (Utf8)gluErrorString(error);
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
  fail(@"OpenGL: %s", s.UTF8String);
}

