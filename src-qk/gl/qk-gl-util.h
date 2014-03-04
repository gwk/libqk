// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"
#import "qk-vec.h"


#if QK_OPTIMIZE
# define qkgl_assert() ((void)0)
#else
# define qkgl_assert() qkgl_check()
#endif


void qkgl_set_shader_source(GLuint handle, Ascii source);
GLint qkgl_get_shader_param(GLuint handle, GLenum param_name);
NSString* qkgl_get_shader_info_log(GLuint handle);

GLint qkgl_get_program_param(GLuint handle, GLenum param_name);
NSString* qkgl_get_program_info_log(GLuint handle);

int qkgl_max_vertex_attributes();

NSString* qkgl_error_string(GLenum error);
void qkgl_check();

V2F32 viewportOriginLetterboxed(V2F32 origin, F32 contentAR, F32 canvasAR);
V2F32 viewportScaleLetterboxed(V2F32 scale, F32 contentAR, F32 canvasAR);
