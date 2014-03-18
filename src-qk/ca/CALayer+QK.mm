// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "CALayer+QK.h"


@implementation CALayer (QK)


PROPERTY_STRUCT_FIELD(CGPoint, origin, Origin, CGRect, self.frame, origin);
PROPERTY_STRUCT_FIELD(CGSize, size, Size, CGRect, self.frame, size);
PROPERTY_STRUCT_FIELD(CGFloat, x, X, CGRect, self.frame, origin.x);
PROPERTY_STRUCT_FIELD(CGFloat, y, Y, CGRect, self.frame, origin.y);
PROPERTY_STRUCT_FIELD(CGFloat, w, W, CGRect, self.frame, size.width);
PROPERTY_STRUCT_FIELD(CGFloat, h, H, CGRect, self.frame, size.height);
PROPERTY_STRUCT_FIELD(CGFloat, px, Px, CGPoint, self.position, x);
PROPERTY_STRUCT_FIELD(CGFloat, py, Py, CGPoint, self.position, y);


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


#pragma mark debugging


- (void)inspectRec:(NSString*)indent {
  errL(indent, self, (self.isHidden ? @"(HIDDEN)" : @""));
  NSString* indent1 = [indent stringByAppendingString:@"  "];
  for (CALayer* v  in self.sublayers) {
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
  CALayer* c = self;
  while (c) {
    errL(c, (self.isHidden ? @"(HIDDEN)" : @""));
    c = c.superlayer;
  }
  errL();
}


- (void)inspectParents:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  [self inspectParents];
}


@end

