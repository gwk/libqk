// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-block-types.h"
#import "CRView.h"

@interface QKLayoutView : CRView

@property (nonatomic, copy) BlockAction blockPre; // first step of layoutSubviews.
@property (nonatomic, copy) BlockAction blockPost; // last step of layoutSubviews.
@property (nonatomic) BOOL fit;
@property (nonatomic) QKLayoutDirection direction;
@property (nonatomic) CGFloat margin;

@end

