// Copyright 2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "CUIColor.h"


@interface NSView (QK)

@property (nonatomic) CGPoint center;
@property (nonatomic) CUIColor* backgroundColor;
@property (nonatomic) BOOL opaque;

- (void)setupLayer;
- (void)setNeedsDisplay;
- (void)setNeedsLayout;

@end
