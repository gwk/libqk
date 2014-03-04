// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "CALayer+QK.h"


@implementation CALayer (QK)


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

