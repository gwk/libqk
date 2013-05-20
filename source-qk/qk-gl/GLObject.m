// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSString+QK.h"
#import "GLObject.h"


@implementation GLObject


- (void)dealloc {
  [self dissolve];
}


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %d>", self.class, self, _handle];
}


- (void)dissolve {
  MUST_OVERRIDE;
}


@end
