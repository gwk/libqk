// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSArray+QK.h"
#import "NSString+QK.h"
#import "GLProgram.h"


@interface GLProgram ()

@property (nonatomic) NSArray* shaders;

@end


@implementation GLProgram


- (void)dealloc {
  glDeleteProgram(_handle);
}


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p %d; %@>", self.class, self, _handle, _shaders];
}


- (id)initWithShaders:(NSArray*)shaders {
  INIT(super init);
  _shaders = shaders;
  _handle = glCreateProgram(); qkgl_assert();
  for (GLShader* s in shaders) {
    glAttachShader(_handle, s.handle); qkgl_assert();
  }
  glLinkProgram(_handle); qkgl_assert();
  check(qkgl_get_program_param(_handle, GL_LINK_STATUS),
        @"program link failed: %@\n", self.infoLog);
  
  if (!QK_OPTIMIZE) {
    glValidateProgram(_handle); qkgl_assert();
    check(qkgl_get_program_param(_handle, GL_VALIDATE_STATUS),
          @"program validation failed: %@\n", self.infoLog);
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
  glUseProgram(_handle); qkgl_assert();
}


+ (void)disable {
  glUseProgram(0); qkgl_assert();
}


- (NSString*)infoLog {
  return qkgl_get_program_info_log(_handle);
}


- (GLint)locForAttribute:(NSString*)attribute {
  GLint loc = glGetAttribLocation(_handle, attribute.asUtf8); qkgl_assert();
  check(loc != -1, @"bad attribute: %@", attribute);
  return loc;
}


- (GLint)locForUniform:(NSString*)uniform {
  GLint loc = glGetUniformLocation(_handle, uniform.asUtf8); qkgl_assert();
  check(loc != -1, @"bad uniform: %@", uniform);
  return loc;
}


@end
