// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"


@interface NSView (QK)

@property (nonatomic) CGPoint center;

// these are defined only to match the property field structs declared in UIView+QK
- (CGPoint)boundsOrigin;
- (CGSize)boundsSize;

- (void)setNeedsDisplay;

@end
