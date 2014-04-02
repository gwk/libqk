// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <QuartzCore/QuartzCore.h>

#import "CUIColor.h"


@interface CALayer (CUI)

@property (nonatomic) CUIColor* color;

DEC_INIT(Frame:(CGRect)frame color:(CUIColor*)color);

@end
