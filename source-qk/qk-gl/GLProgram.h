// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GlVertexShader.h"
#import "GLFragmentShader.h"


@interface GLProgram : GLObject

- (id)initWithShaders:(NSArray*)shaders;
+ (id)withShaders:(NSArray*)shaders;
+ (id)withShaderNames:(NSArray*)shaderNames;

- (void)use;
+ (void)disable;

- (GLint)locForAttribute:(NSString*)attribute;
- (GLint)locForUniform:(NSString*)uniform;

@end
