// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSView+QK.h"


@implementation NSView (QK)


- (CGPoint)center {
  CGRect f = self.frame;
  return CGPointMake(f.origin.x + f.size.width * .5, f.origin.y + f.size.height * .5);
};


- (void)setCenter:(CGPoint)center {
  CGRect f = self.frame;
  f.origin = CGPointMake(center.x - f.size.width * .5, center.y - f.size.height * .5);
  self.frame = f;
}


- (CGPoint)boundsOrigin {
  return self.bounds.origin;
}


- (CGSize)boundsSize {
  return self.bounds.size;
}


- (void)setNeedsDisplay {
  [self setNeedsDisplay:YES];
}


@end
