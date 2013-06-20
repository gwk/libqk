// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKLayoutView.h"


@interface QKLayoutView ()
@end


@implementation QKLayoutView



- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  _direction = QKLayoutVertical;
  return self;
}


// layoutSubviews is sent to parent before children.
- (void)layoutSubviews {
  APPLY_LIVE_BLOCK(_blockPre);
  CGPoint p = self.bounds.origin;
  CGFloat l = 0; // length
  for (CUIView* v in self.subviews) {
#if TARGET_OS_IPHONE
    if (_fit) {
      [v sizeToFit];
    }
#endif
    if (_direction == QKLayoutHorizontal) {
      v.origin = p;
      l = v.right;
      p.x = l + _margin;
    }
    else if (_direction == QKLayoutVertical) {
      v.origin = p;
      l = v.bottom;
      p.y = l + _margin;
    }
  }
  if (_direction == QKLayoutHorizontal) {
    self.width = l;
  }
  else if (_direction == QKLayoutVertical) {
    self.height = l;
  }
  APPLY_LIVE_BLOCK(_blockPost);
}


@end

