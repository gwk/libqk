// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CUIView.h"
#import "QKHighlightingView.h"


@interface UILabel (QK) <QKHighlightingView>

+ (id)withFont:(UIFont*)font lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex;
+ (id)withFontSize:(CGFloat)fontSize lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex;
+ (id)withFontBoldSize:(CGFloat)fontSize lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex;

@end

