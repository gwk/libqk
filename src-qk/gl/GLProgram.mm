// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-gl-util.h"
#import "NSArray+QK.h"
#import "NSString+QK.h"
#import "GLProgram.h"


@interface GLProgram ()

@property (nonatomic) NSArray* shaders;
@property (nonatomic) NSArray* uniforms;
@property (nonatomic) NSArray* attributes;
@property (nonatomic) NSDictionary* uniformLocations;
@property (nonatomic) NSDictionary* attributeLocations;

@end


@implementation GLProgram


- (void)dissolve {
  for (GLShader* s in _shaders) {
    [s dissolve];
  }
  glDeleteProgram(_handle); qkgl_assert();
  _handle = 0;
}


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p %d; %@>", self.class, self, _handle, _shaders];
}


DEF_INIT(Shaders:(NSArray*)shaders uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes) {
  INIT(super init);
  _shaders = shaders;
  _uniforms = uniforms;
  _attributes = attributes;
  _handle = glCreateProgram(); qkgl_assert();
  for (GLShader* s in shaders) {
    glAttachShader(_handle, s.handle); qkgl_assert();
  }
  glLinkProgram(_handle); qkgl_assert();
  qk_check(qkgl_get_program_param(_handle, GL_LINK_STATUS),
        @"program link failed: %@\n", self.infoLog);
  if (!QK_OPTIMIZE) {
    glValidateProgram(_handle); qkgl_assert();
    qk_check(qkgl_get_program_param(_handle, GL_VALIDATE_STATUS),
          @"program validation failed: %@\n", self.infoLog);
  }
  
  // is it even possible to get here?
  qk_check(_attributes.count <= qkgl_max_vertex_attributes(),
        @"too many attributes (max %d): %@", qkgl_max_vertex_attributes(), _attributes);

  // GLSL will optimize out unused uniforms/attributes, which is annyoing during development and debugging.
  // to mitigate this, we print a note when names are missing, rather than throw an error.
  _uniformLocations = [_uniforms mapToDict:^(NSString *name){
    GLint loc = glGetUniformLocation(_handle, name.asUtf8);
    if (loc == -1) {
      errFL(@"NOTE: no location for shader uniform: %@", name);
    }
    return [QKDuo a:name b:@(loc)];
  }];
  _attributeLocations  = [_attributes mapToDict:^(NSString *name){
    GLint loc = glGetAttribLocation(_handle, name.asUtf8);
    if (loc == -1) {
      errFL(@"NOTE: no location for shader attribute: %@", name);
    }
    return [QKDuo a:name b:@(loc)];
  }];

  return self;
}


DEF_INIT(ShaderNames:(NSArray*)shaderNames uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes) {
  NSArray* shaders = [shaderNames map:^(id el){
    NSArray* resourceNames = IS_KIND(el, NSArray) ? el : @[el];
    return [GLShader withResourceNames:resourceNames];
  }];
  return [self initWithShaders:shaders uniforms:uniforms attributes:attributes];
}


- (void)use {
  glUseProgram(_handle); qkgl_assert();
  for (NSNumber* loc in _attributeLocations.allValues) {
    if (loc.intValue != -1) {
      glEnableVertexAttribArray(loc.intValue); qkgl_assert();
    }
  }
}


+ (void)disable {
  glUseProgram(0); qkgl_assert();
}


- (NSString*)infoLog {
  return qkgl_get_program_info_log(_handle);
}


- (GLint)locForAttribute:(NSString*)attribute {
  GLint loc = glGetAttribLocation(_handle, attribute.asUtf8); qkgl_assert();
  qk_check(loc != -1, @"bad attribute: %@", attribute);
  return loc;
}


- (GLint)locForUniform:(NSString*)uniform {
  GLint loc = glGetUniformLocation(_handle, uniform.asUtf8); qkgl_assert();
  qk_check(loc != -1, @"bad uniform: %@", uniform);
  return loc;
}


#define CHECK_UNIFORM \
NSNumber* loc = [_uniformLocations objectForKey:name]; \
qk_check(loc, @"bad uniform: %@", name); \
if (loc.intValue == -1) return NO; \

#define SET_UNIFORM(T, T_GL, f) \
- (BOOL)setUniform:(NSString*)name count:(int)count T:(T*)pointer { \
CHECK_UNIFORM \
f(loc.intValue, count, (T_GL*)pointer); qkgl_assert(); \
return YES; \
} \
\
- (BOOL)setUniform:(NSString*)name T:(T)val { \
  return [self setUniform:name count:1 T:&val]; \
}

#define SET_MAT_UNIFORM(T, f) \
- (BOOL)setUniform:(NSString*)name T:(T*)pointer { \
CHECK_UNIFORM \
f(loc.intValue, 1, GL_FALSE, pointer->m); \
return YES; \
}

SET_UNIFORM(F32,    GLfloat, glUniform1fv);
SET_UNIFORM(V2F32,  GLfloat, glUniform2fv);
SET_UNIFORM(V3F32,  GLfloat, glUniform3fv);
SET_UNIFORM(V4F32,  GLfloat, glUniform4fv);
SET_UNIFORM(I32,    GLint, glUniform1iv);

#if QK_USE_GLK
SET_MAT_UNIFORM(M2, glUniformMatrix2fv);
SET_MAT_UNIFORM(M3, glUniformMatrix3fv);
SET_MAT_UNIFORM(M4, glUniformMatrix4fv);
#endif

- (BOOL)setUniform:(NSString *)name CGAffineTransform:(CGAffineTransform)t {
  CHECK_UNIFORM;
  // CGAffineTransform definition is described as transpose of OpenGL matrices;
  // OpenGL expects column-major matrices but the natural C layout is row-major, so it ends up looking normal.
  F32 m[9] = { // column major OpenGL layout
    static_cast<F32>(t.a),  static_cast<F32>(t.b),  0,
    static_cast<F32>(t.c),  static_cast<F32>(t.d),  0,
    static_cast<F32>(t.tx), static_cast<F32>(t.ty), 1,
  };
  // OpenGL ES requires that the transpose flag be false, so it is useless.
  glUniformMatrix3fv(loc.intValue, 1, GL_FALSE, m); qkgl_assert();
  return YES;
}


- (BOOL)setUniform:(NSString *)name texture:(GLTexture*)texture unit:(I32)unit {
  // NOTE: this addition assumes that the unit enums are consecutive.
  glActiveTexture(GL_TEXTURE0 + unit); qkgl_assert();
  [GLTexture bind:texture target:GL_TEXTURE_2D];
  return [self setUniform:name I32:unit];
}

- (BOOL)setAttribute:(NSString*)name
                size:(int)size
                type:(GLenum)type
           normalize:(BOOL)normalize
              stride:(int)stride
             pointer:(const void*)pointer {
  
  NSNumber* loc = [_attributeLocations objectForKey:name];
  qk_check(loc, @"bad attribute: %@", name);
  if (loc.intValue == -1) { // known missing name
    return NO;
  }
  glVertexAttribPointer(loc.intValue, size, type, normalize, stride, pointer); qkgl_assert();
  return YES;
}


- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerF32:(const F32*)pointer {
  return [self setAttribute:name size:1 type:GL_FLOAT normalize:NO stride:stride pointer:pointer];
}


- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerV2F32:(const V2F32*)pointer {
  return [self setAttribute:name size:2 type:GL_FLOAT normalize:NO stride:stride pointer:pointer];
}


- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerV3F32:(const V3F32*)pointer {
  return [self setAttribute:name size:3 type:GL_FLOAT normalize:NO stride:stride pointer:pointer];
}


- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerV4F32:(const V4F32*)pointer {
  return [self setAttribute:name size:4 type:GL_FLOAT normalize:NO stride:stride pointer:pointer];
}


- (BOOL)setAttributeToUnitSquareV2F32:(NSString*)name {
  const V2F32 unit_square[4] = {
    {{0, 0}},
    {{1, 0}},
    {{0, 1}},
    {{1, 1}},
  };
  return [self setAttribute:name stride:0 pointerV2F32:unit_square];
}


@end
