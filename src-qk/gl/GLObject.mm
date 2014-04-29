// Copyright 2007-2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "NSString+QK.h"
#import "GLObject.h"


@implementation GLObject


- (void)dealloc {
  [self dissolve];
}


- (NSString*)description {
  return fmt(@"<%@ %p: %d>", self.class, self, _handle);
}


- (void)dissolve {
  MUST_OVERRIDE;
}


@end
