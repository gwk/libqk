// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-vec.h"
#import "QKStructArray.h"
#import "GLProgram.h"
#import "GLTestScene.h"


@interface GLTestScene ()

@property (nonatomic) GLProgram* gradientProgram;
@property (nonatomic) GLProgram* solidProgram;
@property (nonatomic) QKStructArray* spokes;

@end


@implementation GLTestScene


- (void)setupGLLayer:(CCAGLLayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info {
  
  _gradientProgram = [GLProgram withShaderNames:@[@[@"viewport2.vert", @"pos-color.vert"], @"var-color.frag"]
                               uniforms:@[@"origin", @"scale"]
                             attributes:@[@"pos"]];

  _solidProgram = [GLProgram withShaderNames:@[@[@"viewport2.vert", @"pos.vert"], @"uni-color.frag"]
                                    uniforms:@[@"origin", @"scale", @"color"]
                                  attributes:@[@"pos"]];
  
  int c = 64;
  F32 step = M_PI_2 / c;
  _spokes = [QKStructArray withElSize:sizeof(V2F32) from:0 to:c + 2 mapIntBlock:^(V2F32* v, int i){
    F32 r =i * step;
    *v = i % 2 ? V2F32Zero : (V2F32){ cos(r), sin(r) };
  }];
  
}


- (void)drawInGLLayer:(CCAGLLayer*)layer time:(NSTimeInterval)time info:(GLCanvasInfo*)info {
  LOG_METHOD;
  glClearColor(0, 0, 0, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [_gradientProgram use];
  [_gradientProgram setUniform:@"origin" V2F32:V2F32Zero];
  [_gradientProgram setUniform:@"scale" V2F32:V2F32Unit];
  [_gradientProgram setAttributeToUnitSquareV2F32:@"pos"];
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
  [_solidProgram use];
  [_solidProgram setUniform:@"origin" V2F32:V2F32Zero];
  [_solidProgram setUniform:@"scale" V2F32:V2F32Unit];
  [_solidProgram setUniform:@"color" V4F32:V4F32Unit];
  [_solidProgram setAttribute:@"pos" stride:0 pointerV2F32:_spokes.bytes];
  glDrawArrays(GL_LINE_STRIP, 0, _spokes.count);
}


@end

