// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSArray+QK.h"
#import "NSBundle+QK.h"
#import "NSString+QK.h"
#import "qk-gl-util.h"
#import "GLVertexShader.h"
#import "GLFragmentShader.h"
#import "GLShader.h"


@interface GLShader ()

@property (nonatomic) NSString* source;

@end


@implementation GLShader


- (void)dissolve {
  glDeleteShader(_handle); qkgl_assert();
  _handle = 0;
}


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %d>", self.class, self, _handle];
}


+ (NSString*)prefix {
  return
#if TARGET_OS_IPHONE
  @""
#else
  // ignore GLSL ES precision specifiers
  @"#define lowp   \n"
  @"#define mediump\n"
  @"#define highp  \n"
  @"\n"
#endif
  ;
}


LAZY_STATIC_METHOD(Int, prefixLineCount, [[self prefix] lineCount]);


DEF_INIT(Sources:(NSArray*)sources name:(NSString*)name) {
  INIT(super init);
  _name = name;
  _handle = glCreateShader([self.class shaderType]); qkgl_assert();
  qk_assert(_handle, @"no handle");
  _source = [[self.class prefix] stringByAppendingString:[sources componentsJoinedByString:@"\n"]];
  qkgl_set_shader_source(_handle, _source.UTF8String);
  glCompileShader(_handle); qkgl_assert();
  
  qk_check(qkgl_get_shader_param(_handle, GL_COMPILE_STATUS),
        @"shader compile failed: %@\n%@\nsource:\n%@\n",
        _name, self.infoLog, _source.numberedLines);
  
  return self;
}


+ (id)withResourceNames:(NSArray*)resourceNames {
  
  static NSDictionary* ext_classes = nil;
  if (!ext_classes) {
    ext_classes = @{
    @"vert" : [GLVertexShader class],
    @"frag" : [GLFragmentShader class],
    };
  }
  
  NSString* ext0 = [resourceNames.el0 pathExtension];
  Class c = [ext_classes objectForKey:ext0];
  qk_assert(c, @"bad shader name extension: %@", resourceNames.el0);
  NSArray* sources = [resourceNames map:^(NSString* name){
    qk_assert([ext0 isEqualToString:name.pathExtension], @"mismatched shader name extension: %@", name);
    NSString* path = [NSBundle resPath:name];
    NSError* e = nil;
    NSString* source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
    qk_check(!e, @"could not read shader source at path: %@\n%@", path, e);
    return source;
  }];
  return [c withSources:sources name:resourceNames.elLast];
}


+ (GLenum)shaderType {
  MUST_OVERRIDE;
}


- (NSString*)infoLog {
  return qkgl_get_shader_info_log(_handle);
}


@end
