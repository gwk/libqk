// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-cg-util.h"
#import "CUIView.h"


#if TARGET_OS_IPHONE
#import "UIView+QK.h"

const UIFlex UIFlexNone   = UIViewAutoresizingNone;
const UIFlex UIFlexWidth  = UIViewAutoresizingFlexibleWidth;
const UIFlex UIFlexHeight = UIViewAutoresizingFlexibleHeight;
const UIFlex UIFlexLeft   = UIViewAutoresizingFlexibleLeftMargin;
const UIFlex UIFlexRight  = UIViewAutoresizingFlexibleRightMargin;
const UIFlex UIFlexTop    = UIViewAutoresizingFlexibleTopMargin;
const UIFlex UIFlexBottom = UIViewAutoresizingFlexibleBottomMargin;
#else
const UIFlex UIFlexNone   = NSViewNotSizable;
const UIFlex UIFlexWidth  = NSViewWidthSizable;
const UIFlex UIFlexHeight = NSViewHeightSizable;
const UIFlex UIFlexLeft   = NSViewMinXMargin;
const UIFlex UIFlexRight  = NSViewMaxXMargin;
const UIFlex UIFlexTop    = NSViewMaxYMargin;
const UIFlex UIFlexBottom = NSViewMinYMargin;
#endif

const UIFlex UIFlexSize       = UIFlexWidth | UIFlexHeight;
const UIFlex UIFlexHorizontal = UIFlexLeft | UIFlexRight;
const UIFlex UIFlexVertical   = UIFlexTop | UIFlexBottom;
const UIFlex UIFlexPosition   = UIFlexHorizontal | UIFlexVertical;
const UIFlex UIFlexWidthLeft    = UIFlexWidth | UIFlexLeft;
const UIFlex UIFlexWidthRight   = UIFlexWidth | UIFlexRight;


@implementation CUIView (CUI)



DEF_WITH(Frame:(CGRect)frame);


DEF_INIT(Frame:(CGRect)frame flex:(UIFlex)flex) {
  INIT(self initWithFrame:frame);
  self.autoresizingMask = flex;
  return self;
}


DEF_INIT(FlexFrame:(CGRect)frame) {
  return [self initWithFrame:frame flex:UIFlexSize];
}


DEF_INIT(FlexFrame) {
  // using a small square frame will reveal any omitted autoresizing bits.
  return [self initWithFlexFrame:CGRect256];
}


PROPERTY_STRUCT_FIELD(CGPoint, origin, Origin, CGRect, self.frame, origin);
PROPERTY_STRUCT_FIELD(CGSize, size, Size, CGRect, self.frame, size);
PROPERTY_STRUCT_FIELD(CGFloat, x, X, CGRect, self.frame, origin.x);
PROPERTY_STRUCT_FIELD(CGFloat, y, Y, CGRect, self.frame, origin.y);
PROPERTY_STRUCT_FIELD(CGFloat, width, Width, CGRect, self.frame, size.width);
PROPERTY_STRUCT_FIELD(CGFloat, height, Height, CGRect, self.frame, size.height);
PROPERTY_STRUCT_FIELD(CGFloat, centerX, CenterX, CGPoint, self.center, x);
PROPERTY_STRUCT_FIELD(CGFloat, centerY, CenterY, CGPoint, self.center, y);


- (CGFloat)right {
  CGRect f = self.frame;
  return f.origin.x + f.size.width;
}


- (void)setRight:(CGFloat)right {
  CGRect f = self.frame;
  f.origin.x = right - f.size.width;
  self.frame = f;
}


- (CGFloat)bottom {
  CGRect f = self.frame;
  return f.origin.y + f.size.height;
}


- (void)setBottom:(CGFloat)bottom {
  CGRect f = self.frame;
  f.origin.y = bottom - f.size.height;
  self.frame = f;
}


- (CGPoint)boundsCenter {
  CGRect b = self.bounds;
  return CGPointMake(b.origin.x + b.size.width * .5, b.origin.y + b.size.height * .5);
}


- (void)setBoundsCenter:(CGPoint)boundsCenter {
  CGSize s = self.bounds.size;
  self.boundsOrigin = CGPointMake(boundsCenter.x - s.width * .5, boundsCenter.y - s.height * .5);
}


#pragma mark debugging


- (void)inspectRec:(NSString*)indent {
  errL(indent, self, (self.isHidden ? @"(HIDDEN)" : @""));
  NSString* indent1 = [indent stringByAppendingString:@"  "];
  for (CUIView* v  in self.subviews) {
    [v inspectRec:indent1];
  }
}


- (void)inspect {
  [self inspectRec:@""];
  errL();
}


- (void)inspect:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  [self inspect];
}


- (void)inspectParents {
  CUIView* v = self;
  while (v) {
    errL(v, (self.isHidden ? @"(HIDDEN)" : @""));
    v = v.superview;
  }
  errL();
}


- (void)inspectParents:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  [self inspectParents];
}


@end

