// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIView+QK.h"

const UIViewAutoresizing UIFlexNone   = UIViewAutoresizingNone;
const UIViewAutoresizing UIFlexWidth  = UIViewAutoresizingFlexibleWidth;
const UIViewAutoresizing UIFlexHeight = UIViewAutoresizingFlexibleHeight;
const UIViewAutoresizing UIFlexLeft   = UIViewAutoresizingFlexibleLeftMargin;
const UIViewAutoresizing UIFlexRight  = UIViewAutoresizingFlexibleRightMargin;
const UIViewAutoresizing UIFlexTop    = UIViewAutoresizingFlexibleTopMargin;
const UIViewAutoresizing UIFlexBottom = UIViewAutoresizingFlexibleBottomMargin;

const UIViewAutoresizing UIFlexSize       = UIFlexWidth | UIFlexHeight;
const UIViewAutoresizing UIFlexHorizontal = UIFlexLeft | UIFlexRight;
const UIViewAutoresizing UIFlexVertical   = UIFlexTop | UIFlexBottom;


@implementation UIView (QK)


- (id)initWithFrame:(CGRect)frame flex:(UIViewAutoresizing)flex {
  INIT(self initWithFrame:frame);
  self.autoresizingMask = flex;
  return self;
}


- (id)initWithFlexFrame:(CGRect)frame {
  return [self initWithFrame:frame flex:UIFlexSize];
}


- (id)initWithFlexFrame {
  // using a small square frame will reveal any omitted autoresizing bits.
  return [self initWithFlexFrame:CGRectMake(0, 0, 320, 320)];
}


+ (id)withFrame:(CGRect)frame {
  return [[self alloc] initWithFrame:frame];
}


+ (id)withFrame:(CGRect)frame flex:(UIViewAutoresizing)flex {
  return [[self alloc] initWithFrame:frame flex:flex];
}


+ (id)withFlexFrame:(CGRect)frame {
  return [[self alloc] initWithFlexFrame:frame];
}


+ (id)withFlexFrame {
  return [[self alloc] initWithFlexFrame];
}


+ (id)withFrame:(CGRect)frame color:(UIColor*)color {
  UIView* v = [self withFrame:frame];
  v.opaque = (color.a == 1.0);
  v.backgroundColor = color;
  return v;
}


PROPERTY_STRUCT_FIELD(CGPoint, origin, Origin, CGRect, self.frame, origin);
PROPERTY_STRUCT_FIELD(CGSize, size, Size, CGRect, self.frame, size);
PROPERTY_STRUCT_FIELD(CGFloat, x, X, CGRect, self.frame, origin.x);
PROPERTY_STRUCT_FIELD(CGFloat, y, Y, CGRect, self.frame, origin.y);
PROPERTY_STRUCT_FIELD(CGFloat, width, Width, CGRect, self.frame, size.width);
PROPERTY_STRUCT_FIELD(CGFloat, height, Height, CGRect, self.frame, size.height);
PROPERTY_STRUCT_FIELD(CGFloat, centerX, CenterX, CGPoint, self.center, x);
PROPERTY_STRUCT_FIELD(CGFloat, centerY, CenterY, CGPoint, self.center, y);

PROPERTY_STRUCT_FIELD(CGPoint, boundsOrigin, BoundsOrigin, CGRect, self.bounds, origin);
PROPERTY_STRUCT_FIELD(CGSize, boundsSize, BoundsSize, CGRect, self.bounds, size);


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
  for (UIView* v  in self.subviews) {
    [v inspectRec:indent1];
  }
}


- (void)inspect:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  [self inspectRec:@""];
  errL();
}


- (void)inspectParents:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  UIView* v = self;
  while (v) {
    errL(v, (self.isHidden ? @"(HIDDEN)" : @""));
    v = v.superview;
  }
  errL();
}

@end
