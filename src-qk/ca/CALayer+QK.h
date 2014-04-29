// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "CUIColor.h"


@interface CALayer (QK)

@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat w;
@property(nonatomic) CGFloat h;
@property(nonatomic) CGFloat r;
@property(nonatomic) CGFloat b;
@property(nonatomic) CGFloat px;
@property(nonatomic) CGFloat py;

@property (nonatomic) CUIColor* color; // background color.

DEC_INIT(Frame:(CGRect)frame);
DEC_INIT(Frame:(CGRect)frame color:(CUIColor*)color);

- (void)inspect;
- (void)inspect:(NSString*)label;
- (void)inspectParents;
- (void)inspectParents:(NSString*)label;

@end

