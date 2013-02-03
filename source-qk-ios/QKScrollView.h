// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKScrollView : UIScrollView <UIScrollViewDelegate>

- (void)addZoomSubview:(UIView*)view constantScale:(BOOL)constantScale;

- (CGSize)zoomSize;

@end

