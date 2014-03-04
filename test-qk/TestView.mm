// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "CUIView.h"
#import "CUIColor.h"
#import "qk-cg-util.h"
#import "QKDisplayLink.h"
#import "TestView.h"


@interface TestView ()

@property(nonatomic) QKDisplayLink* displayLink;
@property(nonatomic) CGPoint a, b, c;

@end


@implementation TestView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  [self setupLayer];
  self.backgroundColor = [CUIColor l:.8];
  WEAK(self);
  self.displayLink = [QKDisplayLink withTracking:NO block:^(QKDisplayLink* l){
    [weak_self setNeedsDisplay];
  }];
  //self.displayLink.paused = YES;
  return self;
}


void drawPoint(CGContextRef ctx, CGPoint p, CGFloat width) {
  float n = 1<<8;
  CUIColor* c = [CUIColor l:(rand() % int(.5 * n + 1)) / n];
  //CUIColor* c = [CUIColor k];
  CGContextSetFillColorWithColor(ctx, c.CGColor);
  CGRect r = (CGRect){ p, {width, width} };
  CGContextFillRect(ctx, r);
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  CGFloat w = 1.0 / layer.contentsScale;
  CGPoint vertices[3] = { _a, _b, _c };
  CGPoint p = _a;
  for_in(i, 1<<12) {
    CGPoint v = vertices[rand() % 3];
    p = mul(add(p, v), .5);
    drawPoint(ctx, p, w);
  }
}


- (void)layoutSublayersOfLayer:(CALayer *)layer {
  CGSize s = self.boundsSize;
  _a = CGPointMake(s.width / 2, 0);
  _b = CGPointMake(0, s.height);
  _c = CGPointMake(s.width, s.height);
}

- (BOOL)isFlipped {
  return YES;
}



@end
