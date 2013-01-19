// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLObject.h"


@implementation GLObject


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %d", self.class, self, _handle];
}


@end
