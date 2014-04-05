// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-log.h"
#import "qk-cg-util.h"
#import "NSString+QK.h"
#import "CALayer+QK.h"
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
const UIFlex UIFlexWidthLeft  = UIFlexWidth | UIFlexLeft;
const UIFlex UIFlexWidthRight = UIFlexWidth | UIFlexRight;



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


DEF_INIT(Size:(CGSize)size) {
  return [self initWithFrame:CGRectWithS(size)];
}


DEF_INIT(FlexSize:(CGSize)size) {
  return [self initWithFlexFrame:CGRectWithS(size)];
}


DEC_WITH(Frame:(CGRect)frame flex:(UIFlex)flex  color:(CUIColor*)color) {
  CUIView* v = [self withFrame:frame flex:flex];
  v.opaque = (color.a >= .999);
  v.backgroundColor = color;
  return v;
}


PROPERTY_ALIAS(UIFlex, flex, Flex, self.autoresizingMask);
PROPERTY_ALIAS(CGPoint, c, C, self.center);

PROPERTY_STRUCT_FIELD(CGPoint, o, O, CGRect, self.frame, origin);
PROPERTY_STRUCT_FIELD(CGSize, s, S, CGRect, self.frame, size);
PROPERTY_STRUCT_FIELD(CGFloat, x, X, CGRect, self.frame, origin.x);
PROPERTY_STRUCT_FIELD(CGFloat, y, Y, CGRect, self.frame, origin.y);
PROPERTY_STRUCT_FIELD(CGFloat, w, W, CGRect, self.frame, size.width);
PROPERTY_STRUCT_FIELD(CGFloat, h, H, CGRect, self.frame, size.height);
PROPERTY_STRUCT_FIELD(CGFloat, cx, Cx, CGPoint, self.center, x);
PROPERTY_STRUCT_FIELD(CGFloat, cy, Cy, CGPoint, self.center, y);
PROPERTY_STRUCT_FIELD(CGPoint, bo, Bo, CGRect, self.bounds, origin);
PROPERTY_STRUCT_FIELD(CGSize, bs, Bs, CGRect, self.bounds, size);


- (CGFloat)r {
  CGRect f = self.frame;
  return f.origin.x + f.size.width;
}


- (void)setR:(CGFloat)r {
  CGRect f = self.frame;
  f.origin.x = r - f.size.width;
  self.frame = f;
}


- (CGFloat)b {
  CGRect f = self.frame;
  return f.origin.y + f.size.height;
}


- (void)setB:(CGFloat)b {
  CGRect f = self.frame;
  f.origin.y = b - f.size.height;
  self.frame = f;
}


- (CGPoint)bc {
  CGRect b = self.bounds;
  return CGPointMake(b.origin.x + b.size.width * .5, b.origin.y + b.size.height * .5);
}


- (void)setBc:(CGPoint)bc {
  CGSize s = self.bounds.size;
  self.bo = CGPointMake(bc.x - s.width * .5, bc.y - s.height * .5);
}


#pragma mark subviews


- (void)removeAllSubviews {
  for (CUIView* v in self.subviews) {
    [v removeFromSuperview];
  }
}


#pragma mark debugging


- (NSString*)descFrame {
  return NSStringFromCGRect(self.frame);
}


- (NSString*)descBounds {
  return NSStringFromCGRect(self.bounds);
}


- (NSString*)descCenter {
  return NSStringFromCGPoint(self.center);
}


- (NSString*)descFlex {
  static NSDictionary* bits =
  @{
    @(UIFlexWidth)  : @"W",
    @(UIFlexHeight) : @"H",
    @(UIFlexLeft)   : @"L",
    @(UIFlexRight)  : @"R",
    @(UIFlexTop)    : @"T",
    @(UIFlexBottom) : @"B",
    };
  UIFlex f = self.flex;
  NSMutableArray* a = [NSMutableArray new];
  for (NSNumber* bit in bits) {
    if (bit.unsignedIntValue & f) {
      [a addObject:bits[bit]];
    }
  }
  return [a componentsJoinedByString:@""];
}


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

