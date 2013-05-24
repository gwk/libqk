// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"
#import "qk-cg-util.h"
#import "QKLitView.h"
#import "UILabel+QK.h"


@interface QKLabel : UILabel <QKLitView> {
  BOOL _isLit; // exposed for QKButton, which needs to set the bit without invoking setIsLit.
}

@property (nonatomic) UIEdgeInsets pad;
@property (nonatomic) QKVerticalAlign verticalAlign;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic) UIColor* color; // normal background color
@property (nonatomic) UIColor* litColor; // highlighted background color
@property (nonatomic) UIColor* litTextColor;  // alias for highlightedTextColor.
@property (nonatomic) UIColor* placeholderColor; // text color for placeholder
@property (nonatomic) BOOL isLit; // alias for highlighted, but also affects backgroundColor.

- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform;

DEC_DEFAULT(UIColor*, Color);
DEC_DEFAULT(UIColor*, LitColor);
DEC_DEFAULT(UIColor*, TextColor);
DEC_DEFAULT(UIColor*, LitTextColor);
DEC_DEFAULT(UIColor*, PlaceholderColor);



@end

