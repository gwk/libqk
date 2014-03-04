// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "CUIColor.h"


@interface NSView (QK)

@property (nonatomic) CGPoint center;
@property (nonatomic) CUIColor* backgroundColor;
@property (nonatomic) BOOL opaque;

// NSView already defines setBoundsOrigin; define the accessor to match the PROPERTY_STRUCT_FIELD declaration in UIView+QK.
- (CGPoint)boundsOrigin;
// NSView already defines setBoundsSize; define the accessor to match the PROPERTY_STRUCT_FIELD declaration in UIView+QK.
- (CGSize)boundsSize;
// boundsRotation?

- (void)setupLayer;
- (void)setNeedsDisplay;
- (void)setNeedsLayout;

@end
