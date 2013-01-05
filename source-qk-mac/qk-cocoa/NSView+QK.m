// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSView+QK.h"


@implementation NSView (QK)


// MARK: debugging


- (void)inspectRec:(NSString*)indent {
  
  errL(indent, self, (self.isHidden ? @"(HIDDEN)" : @""));
  
  NSString* indent1 = [indent stringByAppendingString:@"  "];
  for (NSView* v  in self.subviews) {
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
  NSView* v = self;
  while (v) {
    errL(v, (self.isHidden ? @"(HIDDEN)" : @""));
    v = v.superview;
  }
  errL();
}


@end
