// Copyright 2007-2012 George King. All rights reserved.
// Permission to use this file is granted in libqk/license.txt.


#import "NSArray+QK.h"
#import "NSString+QK.h"
#import "GLProgram.h"


@implementation GLProgram


- (void)dealloc {
  glDeleteProgram(_handle);
}


- (id)initWithShaders:(NSArray*)shaders {
  INIT([super init]);
  _handle = glCreateProgram();
  qkgl_assert();
  for (GLShader* s in shaders) {
    glAttachShader(_handle, s.handle);
    qkgl_assert();
  }
  glLinkProgram(_handle);
  qkgl_assert();
  check(qkgl_get_program_param(_handle, GL_LINK_STATUS),
        @"program link failed: %@\n",
        qkgl_get_program_info_log(_handle));
  
  if (!QK_OPTIMIZE) {
    glValidateProgram(_handle);
    check(qkgl_get_program_param(_handle, GL_VALIDATE_STATUS),
          @"program validation failed: %@\n",
          qkgl_get_program_info_log(_handle));
  }
  
  return self;
}


+ (id)withShaders:(NSArray*)shaders {
  return [[self alloc] initWithShaders:shaders];
}


+ (id)withShaderNames:(NSArray*)shaderNames {
  NSArray* shaders = [shaderNames map:^(NSString* resourceName){
    return [GLShader named:resourceName];
  }];
  return [self withShaders:shaders];
}


- (void)use {
  glUseProgram(_handle);
  qkgl_assert();
}


+ (void)disable {
  glUseProgram(0);
  qkgl_assert();
}


- (GLint)locForAttribute:(NSString*)attribute {
  GLint loc = glGetAttribLocation(_handle, attribute.asUtf8);
  qkgl_assert();
  check(loc != -1, @"bad attribute: %@", attribute);
  return loc;
}


- (GLint)locForUniform:(NSString*)uniform {
  GLint loc = glGetUniformLocation(_handle, uniform.asUtf8);
  qkgl_assert();
  check(loc != -1, @"bad uniform: %@", uniform);
  return loc;
}


@end
