// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"
#import "qk-gl-util.h"
#import "GLVertexShader.h"
#import "GLFragmentShader.h"
#import "GLShader.h"


@implementation GLShader


- (void)dealloc {
  glDeleteShader(_handle);
}


- (id)initWithSource:(NSString*)source {
  INIT(super init);
  _handle = glCreateShader([self.class shaderType]);
  qkgl_assert();
  assert(_handle, @"no handle");
  qkgl_set_shader_source(_handle, source.UTF8String);
  glCompileShader(_handle);
  qkgl_assert();
  
  check(qkgl_get_shader_param(_handle, GL_COMPILE_STATUS),
        @"shader compile failed; log: %@\nsource:\n%@\n",
        qkgl_get_shader_info_log(_handle),
        source.numberedLines);
  
  return self;
}


+ (id)withSource:(NSString*)source {
  return [[self alloc] initWithSource:source];
}


+ (id)named:(NSString*)resourceName {
  static NSDictionary* ext_classes = nil;
  if (!ext_classes) {
    ext_classes = @{
    @"vert" : [GLVertexShader class],
    @"frag" : [GLFragmentShader class],
    };
  }
  
  Class c = [ext_classes objectForKey:resourceName.pathExtension];
  assert(c, @"bad shader name extension: %@", resourceName);
  NSString* path = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil];
  NSError* e = nil;
  NSString* source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
  check(!e, @"could not read shader source at path: %@\n%@", path, e);
  return [c withSource:source];
}


+ (GLenum)shaderType {
  OVERRIDE;
}


@end
