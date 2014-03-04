// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GlVertexShader.h"
#import "GLFragmentShader.h"
#import "GLTexture.h"

@interface GLProgram : GLObject

@property (nonatomic, readonly) NSArray* shaders;
@property (nonatomic, readonly) NSArray* uniforms;
@property (nonatomic, readonly) NSArray* attributes;
@property (nonatomic, readonly) NSDictionary* uniformLocations;
@property (nonatomic, readonly) NSDictionary* attributeLocations;

DEC_INIT(Shaders:(NSArray*)shaders uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes);
DEC_INIT(ShaderNames:(NSArray*)shaderNames uniforms:(NSArray*)uniforms attributes:(NSArray*)attributes);

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

#if QK_USE_GLK
- (BOOL)setUniform:(NSString *)name M2:(M2*)val;
- (BOOL)setUniform:(NSString *)name M3:(M3*)val;
- (BOOL)setUniform:(NSString *)name M4:(M4*)val;
#endif

- (BOOL)setUniform:(NSString *)name CGAffineTransform:(CGAffineTransform)t;
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

- (BOOL)setAttributeToUnitSquareV2F32:(NSString*)name;

@end
