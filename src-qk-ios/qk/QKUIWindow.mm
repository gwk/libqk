// Copyright 2014 Normal Ears, Inc.
// All rights reserved.


#import "QKUIWindow.h"


@interface QKUIWindow ()
@end


@implementation QKUIWindow


- (void)sendEvent:(UIEvent*)event {
    // break here to inspect events as they get delivered to views.
    [super sendEvent:event];
}


@end

