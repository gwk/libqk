// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"
#import "qk-cg-util.h"
#import "QKLitView.h"
#import "UILabel+QK.h"


@interface QKLabel : UILabel <QKLitView> {
  BOOL _isLit; // exposed for QKButton, which needs to set the bit without invoking setIsLit.
}

@property (nonatomic) BOOL isLit; // QKLitView; alias for highlighted.

@property (nonatomic) int lineMin; // minimum number of lines; used for size calculations. defaults to 0 (collapse).
@property (nonatomic) int lineMax; // alias for numberOfLines;

@property (nonatomic) UIEdgeInsets pad;
@property (nonatomic) CGFloat padT; // aliases for pad fields.
@property (nonatomic) CGFloat padL;
@property (nonatomic) CGFloat padB;
@property (nonatomic) CGFloat padR;

@property (nonatomic) QKVerticalAlign verticalAlign;
@property (nonatomic, copy) NSString* placeholder; // placeholder string is used when text property is nil.
@property (nonatomic) UIColor* color; // normal background color
@property (nonatomic) UIColor* litColor; // highlighted background color
// TODO: disabledColor?
@property (nonatomic) UIColor* litTextColor;  // alias for highlightedTextColor.
@property (nonatomic) UIColor* placeholderColor; // text color for placeholder

// property defaults for init.
DEC_DEFAULT(UIColor*, Color);
DEC_DEFAULT(UIColor*, LitColor);
DEC_DEFAULT(UIColor*, TextColor);
DEC_DEFAULT(UIColor*, LitTextColor);
DEC_DEFAULT(UIColor*, PlaceholderColor);

+ (id)withFont:(UIFont*)font x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h min:(int)lineMin max:(int)lineMax flex:(UIFlex)flex;
+ (id)withFontSize:(CGFloat)fontSize x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h min:(int)lineMin max:(int)lineMax flex:(UIFlex)flex;
+ (id)withFontBoldSize:(CGFloat)fontSize x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h min:(int)lineMin max:(int)lineMax flex:(UIFlex)flex;

- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform; // binding for text property.
- (void)fitHeight;

@end

