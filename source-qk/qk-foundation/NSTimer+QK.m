// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSTimer+QK.h"


@implementation NSTimer (QK)

- (void)dissolve {
    [self invalidate];
}

@end

