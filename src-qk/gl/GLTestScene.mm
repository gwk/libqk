// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "qk-vec.h"
#import "NSString+QK.h"
#import "QKStructArray.h"
#import "GLProgram.h"
#import "GLLayer.h"
#import "GLTestScene.h"


@interface GLTestScene ()

@property (nonatomic) V2 translation;
@property (nonatomic) F32 scale;
@property (nonatomic) F32 rotation;

@property (nonatomic) GLProgram* gradientProgram;
@property (nonatomic) GLProgram* solidProgram;
@property (nonatomic) QKStructArray* spokes;

@end


@implementation GLTestScene


- (id)init {
  INIT(super init);
  _scale = 1;
  return self;
}


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: t:%@ s:%f r:%f>",
          self.class, self, V2Desc(_translation), _scale, _rotation];
}



- (void)setupGLLayer:(GLLayer*)layer time:(NSTimeInterval)time {
  
  _gradientProgram = [GLProgram withShaderNames:@[@"pos-color.vert", @"var-color.frag"]
                               uniforms:@[@"mvp"]
                             attributes:@[@"pos", @"color"]];

  _solidProgram = [GLProgram withShaderNames:@[@"pos.vert", @"uni-color.frag"]
                                    uniforms:@[@"mvp", @"color"]
                                  attributes:@[@"pos"]];
  
  int n = 32;
  int m = n + 2;
  int c = m * 2;
  int s = 1000; // spoke scale
  F64 step = M_PI_2 / n;
  _spokes = [QKStructArray withElSize:sizeof(V2F32) from:0 to:c   mapIntBlock:^(V2F32* v, int i){
    if (i < m) { // lower
      F64 r = i * step;
      *v = i % 2 ? V2F32Zero : V2F32Make(s * cos(r), s * sin(r));
    }
    else { // upper
      int j = i - m;
      F64 r = j * step;
      *v = i % 2 ? V2F32Unit : V2F32Make(1 - s * cos(r), 1 - s * sin(r));
    }
    //errFL(@"%d %@", i, V2Desc(*v));
  }];
  
}


#define MVTrans2(t)      mv = M4Trans2(mv, t)
#define MVTransXY(x, y)  mv = M4TransXY(mv, x, y)
#define MVScale2(s)      mv = M4Scale2(mv, s)
#define MVScale(s)       mv = M4Scale(mv, s)
#define MVScaleXY(x, y)  mv = M4ScaleXY(mv, x, y)


- (void)drawInGLLayer:(GLLayer*)layer time:(NSTimeInterval)time {
  glClearColor(.1, .1, .1, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  
  V2 contentSize = self.contentSize;
  V2 layerSize = V2F32WithCGSize(layer.bounds.size);
  /*
  F32 layerScale = 1.0 / layerSize.x;
  F32 layerAR = V2F32Aspect(layerSize, .1);
  V2 lcr = V2F32DivVec(layerSize, contentSize);
  V2 clr = V2F32DivVec(contentSize, layerSize);
  */
  // model-view transform.
  // model-to-world composition order is scale, rotate, translate.
  M4 mv = M4Ident;
  MVScale2(contentSize); // model fills content
  // world-to-view composition order is translate, rotate, scale.
  // translation is in pixel coords; convert to world.
  V2 trans = V2Make(2 * _translation.x / layerSize.x, 2 * _translation.y / layerSize.y);
  mv = M4Trans2(mv, V2Neg(trans));
  //mv = M4Scale(mv, _scale);
  
  // projection transform.
  M4 projection = GLKMatrix4MakeOrtho(0, layerSize.x, 0, layerSize.y, 1, -1);
  //OpenGL is in [-1, 1] range but we want [0, 1].
  //MVPTransXY(-lcr.x * 4, 0);
  //MVPScale(2);
  
  /*
  V2F32 offset = layer.eventHandler.translation;
  V2F32 scale = V2F32Make(ms.v[0] * ehs, ms.v[1] * ehs);
  scale = V2F32Make(ehs, ehs);
  LOG(layer.eventHandler);
  */
  
  M4 mvp = GLKMatrix4Multiply(projection, mv);
  [_gradientProgram use];
  [_gradientProgram setUniform:@"mvp" M4:&mvp];
  [_gradientProgram setAttributeToUnitSquareV2F32:@"pos"];
  [_gradientProgram setAttributeToUnitSquareV2F32:@"color"];
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
  [_solidProgram use];
  [_solidProgram setUniform:@"mvp" M4:&mvp];
  [_solidProgram setUniform:@"color" V4F32:V4F32Unit];
  [_solidProgram setAttribute:@"pos" stride:0 pointerV2F32:(V2F32*)_spokes.bytes];
  glDrawArrays(GL_LINES, 0, (int)_spokes.count);
}


- (V2)contentSize {
  CGFloat s = 512 * .5;
  return V2Make(s, s);
}



- (M4)transform {
  return M4TransXY(M4Scale(GLKMatrix4MakeZRotation(_rotation),
                           _scale),
                   _translation.v[0], _translation.v[1]);
}


- (void)setTranslation:(V2)translation layerSize:(V2)layerSize {
  V2 cs = V2Mul(self.contentSize, self.scale);
  errFL(@"%@ %@ %@", V2Desc(translation), V2Desc(layerSize), V2Desc(cs));
  
  BOOL shouldClamp = NO;
  _translation = shouldClamp
  ? V2Make(CLAMP(translation.x, 0, cs.x - layerSize.x),
           CLAMP(translation.y, 0, cs.y - layerSize.y))
  : translation;

}


- (void)adjustTranslation:(V2)delta layerSize:(V2)layerSize {
  delta.v[0] *= -1; // negate and flip y == flip x
  [self setTranslation:V2Add(_translation, delta) layerSize:layerSize];
}


- (void)setRotation:(F32)r {
  _rotation = modAngle(r);
}


- (void)adjustRotation:(F32)r {
  self.rotation = _rotation + 2 * M_PI - r;
}


- (void)setScale:(F32)scale layerSize:(V2)layerSize {
  _scale = scale; // TODO: limit scale to min/max
  [self setTranslation:_translation layerSize:layerSize]; // clamp transalation to new scale.
}


- (void)adjustScale:(F32)factor around:(V2)point layerSize:(V2)layerSize {
  self.scale *= factor;
  [self setTranslation:V2Add(_translation, V2Mul(point, factor - 1)) layerSize:layerSize];
}


- (F32)scalePower {
  return log(_scale) / log(2);
}


- (void)setScalePower:(F32)scalePower {
  self.scale = pow(2, scalePower);
}


@end

