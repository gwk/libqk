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


- (void)inspect:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  [self inspectRec:@""];
  errL();
}


- (void)inspectParents:(NSString*)label {
  errL();
  if (label) errL(label, @":");
  CALayer* v = self;
  while (v) {
    errL(v, (self.isHidden ? @"(HIDDEN)" : @""));
    v = v.superlayer;
  }
  errL();
}


@end

