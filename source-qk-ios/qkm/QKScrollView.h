// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"


@interface QKScrollView : UIView

@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGFloat contentHeight; // alias of contentSize.height
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) BOOL scrollHorizontal;
@property (nonatomic) BOOL scrollVertical;

- (void)scrolled:(CGPoint)offset;

@end

