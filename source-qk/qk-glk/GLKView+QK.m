// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLKView+QK.h"


@implementation GLKView (QK)


- (V2I32)drawableSize {
  return V2I32Make(self.drawableWidth, self.drawableHeight);
}


@end

