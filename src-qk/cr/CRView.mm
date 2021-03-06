// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-log.h"
#import "qk-cr.h"
#import "NSString+QK.h"
#import "CALayer+QK.h"
#import "CRView.h"


#if TARGET_OS_IPHONE
#import "UIView+QK.h"

const UIFlex UIFlexN = UIViewAutoresizingNone;
const UIFlex UIFlexW = UIViewAutoresizingFlexibleWidth;
const UIFlex UIFlexH = UIViewAutoresizingFlexibleHeight;
const UIFlex UIFlexL = UIViewAutoresizingFlexibleLeftMargin;
const UIFlex UIFlexR = UIViewAutoresizingFlexibleRightMargin;
const UIFlex UIFlexT = UIViewAutoresizingFlexibleTopMargin;
const UIFlex UIFlexB = UIViewAutoresizingFlexibleBottomMargin;

const UIAxis UIAxisH = UILayoutConstraintAxisHorizontal;
const UIAxis UIAxisV = UILayoutConstraintAxisVertical;

#else
const UIFlex UIFlexN = NSViewNotSizable;
const UIFlex UIFlexW = NSViewWidthSizable;
const UIFlex UIFlexH = NSViewHeightSizable;
const UIFlex UIFlexL = NSViewMinXMargin;
const UIFlex UIFlexR = NSViewMaxXMargin;
const UIFlex UIFlexT = NSViewMaxYMargin;
const UIFlex UIFlexB = NSViewMinYMargin;

const UIAxis UIAxisH = NSLayoutConstraintOrientationHorizontal;
const UIAxis UIAxisV = NSLayoutConstraintOrientationVertical;

#endif

const UIFlex UIFlexSize = UIFlexW | UIFlexH;
const UIFlex UIFlexHori = UIFlexL | UIFlexR;
const UIFlex UIFlexVert = UIFlexT | UIFlexB;
const UIFlex UIFlexPos = UIFlexHori| UIFlexVert;
const UIFlex UIFlexWL = UIFlexW | UIFlexL;
const UIFlex UIFlexWR = UIFlexW | UIFlexR;


CGContextRef CRCurrentCtx() {
#if TARGET_OS_IPHONE
  return UIGraphicsGetCurrentContext();
#else
  return (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
#endif
}


@implementation CRView (CR)


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


DEF_INIT(Size:(CGSize)size flex:(UIFlex)flex) {
  return [self initWithFrame:CGRectWithS(size) flex:flex];
}


DEC_WITH(Frame:(CGRect)frame flex:(UIFlex)flex  color:(CRColor*)color) {
  CRView* v = [self withFrame:frame flex:flex];
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
PROPERTY_STRUCT_FIELD(CGFloat, bcx, Bcx, CGPoint, self.bc, x);
PROPERTY_STRUCT_FIELD(CGFloat, bcy, Bcy, CGPoint, self.bc, y);
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


- (UILayoutPriority)huggingH {
#if TARGET_OS_IPHONE
    return [self contentHuggingPriorityForAxis:UIAxisH];
#else
    return [self contentHuggingPriorityForOrientation:UIAxisH];
#endif
}


- (void)setHuggingH:(UILayoutPriority)huggingH {
#if TARGET_OS_IPHONE
    return [self setContentHuggingPriority:huggingH forAxis:UIAxisH];
#else
    return [self setContentHuggingPriority:huggingH forOrientation:UIAxisH];
#endif
}


- (UILayoutPriority)huggingV {
#if TARGET_OS_IPHONE
    return [self contentHuggingPriorityForAxis:UIAxisV];
#else
    return [self contentHuggingPriorityForOrientation:UIAxisV];
#endif
}


- (void)setHuggingV:(UILayoutPriority)huggingV {
#if TARGET_OS_IPHONE
    return [self setContentHuggingPriority:huggingV forAxis:UIAxisV];
#else
    return [self setContentHuggingPriority:huggingV forOrientation:UIAxisV];
#endif
}


- (UILayoutPriority)compressionH {
#if TARGET_OS_IPHONE
    return [self contentCompressionResistancePriorityForAxis:UIAxisH];
#else
    return [self contentCompressionResistancePriorityForOrientation:UIAxisH];
#endif
}


- (void)setCompressionH:(UILayoutPriority)compressionH {
#if TARGET_OS_IPHONE
    return [self setContentCompressionResistancePriority:compressionH forAxis:UIAxisH];
#else
    return [self setContentCompressionResistancePriority:compressionH forOrientation:UIAxisH];
#endif
}


- (UILayoutPriority)compressionV {
#if TARGET_OS_IPHONE
    return [self contentCompressionResistancePriorityForAxis:UIAxisV];
#else
    return [self contentCompressionResistancePriorityForOrientation:UIAxisV];
#endif
}


- (void)setCompressionV:(UILayoutPriority)compressionV {
#if TARGET_OS_IPHONE
    return [self setContentCompressionResistancePriority:compressionV forAxis:UIAxisV];
#else
    return [self setContentCompressionResistancePriority:compressionV forOrientation:UIAxisV];
#endif
}


#pragma mark subviews


- (void)removeAllSubviews {
  for (CRView* v in self.subviews) {
    [v removeFromSuperview];
  }
}


- (void)insertSubview:(CRView*)subview comparator:(NSComparator)comparator {
    // for now just do linear search.
    NSArray* views = self.subviews;
    for_in(i, views.count) {
        NSComparisonResult r = comparator(subview, views[i]);
        if (r == NSOrderedAscending) {
            [self insertSubview:subview atIndex:i];
            return;
        }
    }
    [self addSubview:subview];
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
    @{@(UIFlexW) : @"W",
      @(UIFlexH) : @"H",
      @(UIFlexL) : @"L",
      @(UIFlexR) : @"R",
      @(UIFlexT) : @"T",
      @(UIFlexB) : @"B"};
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
  for (CRView* v  in self.subviews) {
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
  CRView* v = self;
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

