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


+ (id)withFrame:(CGRect)frame {
  return [[self alloc] initWithFrame:frame];
}


+ (id)withFrame:(CGRect)frame flex:(UIViewAutoresizing)flex {
  UIView* v = [self withFrame:frame];
  v.autoresizingMask = flex;
  return v;
}


+ (id)withFlexFrame:(CGRect)frame {
  return [self withFrame:frame flex:UIFlexSize];
}


+ (id)withFlexFrame {
  // using a small square frame will reveal any omitted autoresizing bits.
  return [self withFlexFrame:CGRectMake(0, 0, 320, 320)];
}


PROPERTY_STRUCT_FIELD(CGPoint, origin, Origin, CGRect, frame, origin);
PROPERTY_STRUCT_FIELD(CGSize, size, Size, CGRect, frame, size);
PROPERTY_STRUCT_FIELD(CGFloat, x, X, CGRect, frame, origin.x);
PROPERTY_STRUCT_FIELD(CGFloat, y, Y, CGRect, frame, origin.y);
PROPERTY_STRUCT_FIELD(CGFloat, width, Width, CGRect, frame, size.width);
PROPERTY_STRUCT_FIELD(CGFloat, height, Height, CGRect, frame, size.height);
PROPERTY_STRUCT_FIELD(CGFloat, centerX, CenterX, CGPoint, center, x);
PROPERTY_STRUCT_FIELD(CGFloat, centerY, CenterY, CGPoint, center, y);

PROPERTY_STRUCT_FIELD(CGPoint, boundsOrigin, BoundsOrigin, CGRect, bounds, origin);
PROPERTY_STRUCT_FIELD(CGSize, boundsSize, BoundsSize, CGRect, bounds, size);


- (CGPoint)boundsCenter {
  CGRect b = self.bounds;
  return CGPointMake(b.origin.x + b.size.width * .5, b.origin.y + b.size.height * .5);
}


- (void)setBoundsCenter:(CGPoint)boundsCenter {
  CGSize s = self.bounds.size;
  self.boundsOrigin = CGPointMake(boundsCenter.x - s.width * .5, boundsCenter.y - s.height * .5);
}


@end
