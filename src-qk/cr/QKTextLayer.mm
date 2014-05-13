// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKTextLayer.h"


@interface QKTextLayer ()

@property (nonatomic) CTFramesetterRef framesetter;

@end


@implementation QKTextLayer


- (void)dealloc {
  if (_framesetter) {
    CFRelease(_framesetter);
    _framesetter = NULL;
  }
}


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  //self.contentsScale = [[UIScreen mainScreen] scale];
  self.contentsGravity = kCAGravityCenter;
  return self;
}


DEF_PROPERTY_SET_CF(CTFramesetterRef, framesetter, Framesetter);

- (void)drawInContext:(CGContextRef)ctx {
  
}


@end

