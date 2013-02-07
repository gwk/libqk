// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"
#import "qk-gl-util.h"
#import "GLVertexShader.h"
#import "GLFragmentShader.h"
#import "GLShader.h"


@interface GLShader ()

@property (nonatomic) NSString* source;

@end


@implementation GLShader


- (void)dealloc {
  glDeleteShader(_handle); qkgl_assert();
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


LAZY_CLASS_METHOD(Int, prefixLineCount, [[self prefix] lineCount]);


- (NSString*)sourceNumberedFromOriginal {
  return [_source numberedLinesFrom:1 - [self.class prefixLineCount]];
}


- (id)initWithSource:(NSString*)source name:(NSString*)name {
  INIT(super init);
  _source = [[self.class prefix] stringByAppendingString:source];
  _name = name;
  _handle = glCreateShader([self.class shaderType]); qkgl_assert();
  assert(_handle, @"no handle");
  qkgl_set_shader_source(_handle, _source.UTF8String);
  glCompileShader(_handle); qkgl_assert();
  
  check(qkgl_get_shader_param(_handle, GL_COMPILE_STATUS),
        @"shader compile failed: %@\n%@\nsource:\n%@\n",
        _name, self.infoLog, _source.numberedLines);
  
  return self;
}


+ (id)withSource:(NSString*)source name:(NSString*)name {
  return [[self alloc] initWithSource:source name:name];
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
  NSString* path = [NSBundle resPath:resourceName];
  NSError* e = nil;
  NSString* source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
  check(!e, @"could not read shader source at path: %@\n%@", path, e);
  return [c withSource:source name:resourceName];
}


+ (GLenum)shaderType {
  OVERRIDE;
}


- (NSString*)infoLog {
  return qkgl_get_shader_info_log(_handle);
}


@end
