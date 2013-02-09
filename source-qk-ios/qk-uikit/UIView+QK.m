// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIView+QK.h"


@implementation UIView (QK)


PROPERTY_STRUCT_FIELD(CGPoint, boundsOrigin, BoundsOrigin, CGRect, self.bounds, origin);
PROPERTY_STRUCT_FIELD(CGSize, boundsSize, BoundsSize, CGRect, self.bounds, size);


+ (id)withFrame:(CGRect)frame color:(UIColor*)color {
  UIView* v = [self withFrame:frame];
  v.opaque = (color.a == 1.0);
  v.backgroundColor = color;
  return v;
}


@end
