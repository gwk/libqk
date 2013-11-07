// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "CUIColor.h"
#import "CUIView.h"


@implementation UIView (QK)


PROPERTY_STRUCT_FIELD(CGPoint, boundsOrigin, BoundsOrigin, CGRect, self.bounds, origin);
PROPERTY_STRUCT_FIELD(CGSize, boundsSize, BoundsSize, CGRect, self.bounds, size);


- (void)setupLayer {} // no-op for ios.


- (UIImage*)renderImage {
  CGSize s = self.bounds.size;
  UIGraphicsBeginImageContext(s);
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  // flip y
  CGContextTranslateCTM(currentContext, 0, s.height);
  CGContextScaleCTM(currentContext, 1, -1);
  [self.layer renderInContext:currentContext];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}


@end
