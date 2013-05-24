// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"
#import "CUIView.h"

typedef enum {
  QKLayoutNone,
  QKLayoutHorizontal,
  QKLayoutVertical,
} QKLayoutDirection;

@interface QKLayoutView : CUIView

@property (nonatomic, copy) BlockAction blockPre; // first step of layoutSubviews.
@property (nonatomic, copy) BlockAction blockPost; // last step of layoutSubviews.
@property (nonatomic) BOOL fit;
@property (nonatomic) QKLayoutDirection direction;
@property (nonatomic) CGFloat margin;

@end

