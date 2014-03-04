// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "CADisplayLink+QK.h"


@implementation CADisplayLink (QK)


- (void)dissolve {
  [self invalidate];
}


@end

