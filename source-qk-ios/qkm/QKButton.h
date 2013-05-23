// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"
#import "UIView+QK.h"
#import "QKHighlightingView.h"


@interface QKButton : UIView

@property (nonatomic, copy) BlockAction blockTouchDown;
@property (nonatomic, copy) BlockAction blockTouchUp;
@property (nonatomic, copy) BlockAction blockTouchCancelled;

@property (nonatomic, readonly) BOOL highlighted;

@property (nonatomic) UIColor* color;
@property (nonatomic) UIColor* highlightedColor;

@end

