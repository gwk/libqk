// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"
#import "QKLabel.h"



// subclassing QKLabel is questionable in the long run.
// in particular, if we ever add optional background images, then we will need to be able to inject the lit image to render.
// however, it is convenient for the time being.
@interface QKButton : QKLabel

@property (nonatomic, copy) BlockAction blockTouchDown;
@property (nonatomic, copy) BlockAction blockTouchUp;
@property (nonatomic, copy) BlockAction blockTouchCancelled;

- (void)addLitSubview:(UIView<QKLitView> *)view;

@end

