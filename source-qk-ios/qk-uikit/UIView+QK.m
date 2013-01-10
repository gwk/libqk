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
  return [self withFlexFrame:CGRectMake(0, 0, 320, 320)];
}


@end