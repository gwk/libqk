// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKLayoutView.h"


@interface QKLayoutView ()
@end


@implementation QKLayoutView



- (instancetype)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  _direction = QKLayoutVertical;
  return self;
}


// layoutSubviews is sent to parent before children.
- (void)layoutSubviews {
  APPLY_LIVE_BLOCK(_blockPre);
  CGPoint p = self.bounds.origin;
  CGFloat l = 0; // length
  for (CRView* v in self.subviews) {
#if TARGET_OS_IPHONE
    if (_fit) {
      [v sizeToFit];
    }
#endif
    if (_direction == QKLayoutHorizontal) {
      v.o = p;
      l = v.r;
      p.x = l + _margin;
    }
    else if (_direction == QKLayoutVertical) {
      v.o = p;
      l = v.b;
      p.y = l + _margin;
    }
  }
  if (_direction == QKLayoutHorizontal) {
    self.w = l;
  }
  else if (_direction == QKLayoutVertical) {
    self.h = l;
  }
  APPLY_LIVE_BLOCK(_blockPost);
}


@end

