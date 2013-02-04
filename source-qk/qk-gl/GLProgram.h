// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GlVertexShader.h"
#import "GLFragmentShader.h"
#import "GLTexture.h"

@interface GLProgram : GLObject

- (id)initWithShaders:(NSArray*)shaders uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes;
+ (id)withShaders:(NSArray*)shaders uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes;
+ (id)withShaderNames:(NSArray*)shaderNames uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes;

- (void)use;
+ (void)disable;

- (NSString*)infoLog;

- (GLint)locForAttribute:(NSString*)attribute;
- (GLint)locForUniform:(NSString*)uniform;

- (BOOL)setUniform:(NSString*)name F32:(F32)val;
- (BOOL)setUniform:(NSString*)name V2F32:(V2F32)val;
- (BOOL)setUniform:(NSString*)name V3F32:(V3F32)val;
- (BOOL)setUniform:(NSString*)name V4F32:(V4F32)val;
- (BOOL)setUniform:(NSString*)name I32:(I32)val;
- (BOOL)setUniform:(NSString *)name texture:(GLTexture*)texture unit:(I32)unit;

- (BOOL)setAttribute:(NSString*)name
                size:(int)size
                type:(GLenum)type
           normalize:(BOOL)normalize
              stride:(int)stride
             pointer:(const void*)pointer;

- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerF32:(const F32*)pointer;
- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerV2F32:(const V2F32*)pointer;
- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerV3F32:(const V3F32*)pointer;
- (BOOL)setAttribute:(NSString*)name stride:(int)stride pointerV4F32:(const V4F32*)pointer;

- (BOOL)setAttributeToUnitSquare:(NSString*)name;

@end
