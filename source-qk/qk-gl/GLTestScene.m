// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-vec.h"
#import "GLProgram.h"
#import "GLTestScene.h"


@interface GLTestScene ()

@property (nonatomic) GLProgram* program;

@end


@implementation GLTestScene


- (void)setupGLLayer:(CCAGLLayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info {
  _program = [GLProgram withShaderNames:@[@[@"viewport2.vert", @"pos-color.vert"], @"var-color.frag"]
                               uniforms:@[@"origin", @"scale"]
                             attributes:@[@"pos"]];
}


- (void)drawInGLLayer:(CCAGLLayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info {
  LOG_METHOD;
  glClearColor(0, 0, 0, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [_program use];
  [_program setUniform:@"origin" V2F32:V2F32Zero];
  [_program setUniform:@"scale" V2F32:V2F32Unit];
  [_program setAttributeToUnitSquareV2F32:@"pos"];
  
  glDrawArrays(GL_TRIANGLES, 1, 3);
}


@end

