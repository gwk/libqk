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


- (CGPoint)boundsOrigin {
  return self.bounds.origin;
}


- (void)setBoundsOrigin:(CGPoint)boundsOrigin {
  CGRect b = self.bounds;
  b.origin = boundsOrigin;
  self.bounds = b;
}


- (CGSize)boundsSize {
  return self.bounds.size;
}


- (void)setBoundsSize:(CGSize)boundsSize {
  CGRect b = self.bounds;
  b.size = boundsSize;
  self.bounds = b;
}


- (CGPoint)boundsCenter {
  CGRect b = self.bounds;
  return CGPointMake(b.origin.x + b.size.width * .5, b.origin.y + b.size.height * .5);
}


- (void)setBoundsCenter:(CGPoint)boundsCenter {
  CGSize s = self.bounds.size;
  self.boundsOrigin = CGPointMake(boundsCenter.x - s.width * .5, boundsCenter.y - s.height * .5);
}


@end
