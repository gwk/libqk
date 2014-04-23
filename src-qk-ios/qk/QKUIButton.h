// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UIButton+QK.h"
#import "qk-block-types.h"


@interface QKUIButton : UIButton

@property (nonatomic, copy) BlockAction blockTouchDown;
@property (nonatomic, copy) BlockAction blockTouchUp;
@property (nonatomic, copy) BlockAction blockTouchCanceled;

- (void)setupBasicColors;

@end

