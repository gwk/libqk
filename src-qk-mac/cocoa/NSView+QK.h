// Copyright 2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "CRColor.h"


@interface NSView (QK)

@property (nonatomic) CGPoint center;
@property (nonatomic) CRColor* backgroundColor;
@property (nonatomic) BOOL opaque;

- (void)setupLayer;
- (void)setNeedsDisplay;
- (void)setNeedsLayout;

- (void)insertSubview:(NSView*)view atIndex:(Int)index;

@end
