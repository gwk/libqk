// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


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

NSString* qkgl_error_string(GLenum error);
void qkgl_check();

