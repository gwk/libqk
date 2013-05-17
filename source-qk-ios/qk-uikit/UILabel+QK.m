// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UILabel+QK.h"


@implementation UILabel (QK)


+ (id)withFont:(UIFont*)font lines:(int)lines x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width flex:(UIFlex)flex {
  CGFloat height = font.lineHeight * lines;
  UILabel* l = [UILabel withFrame:CGRectMake(x, y, width, height) flex:flex];
  l.font = font;
  l.numberOfLines = lines;
  return l;
}


+ (id)withFontSize:(CGFloat)fontSize lines:(int)lines x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width flex:(UIFlex)flex {
  return [self withFont:[UIFont systemFontOfSize:fontSize] lines:lines x:x y:y width:width flex:flex];
}


+ (id)withBoldFontSize:(CGFloat)fontSize lines:(int)lines x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width flex:(UIFlex)flex {
  return [self withFont:[UIFont boldSystemFontOfSize:fontSize] lines:lines x:x y:y width:width flex:flex];
}


@end

