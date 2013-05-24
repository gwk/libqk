// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UILabel+QK.h"


@implementation UILabel (QK)


#pragma mark - QKLitView


- (BOOL)isLit {
  return self.highlighted;
}


- (void)setIsLit:(BOOL)isLit {
  self.highlighted = isLit;
}


#pragma mark - QK


// NOTE: this implementation should be kept in sync with that of QKLabel.
+ (id)withFont:(UIFont*)font lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex {
  if (h <= 0) {
    qk_assert(lines > 0, @"lines and height are both zero");
    h = font.lineHeight * lines;
  }
  UILabel* l = [self withFrame:CGRectMake(x, y, w, h) flex:flex];
  l.font = font;
  l.numberOfLines = lines;
  return l;
}


+ (id)withFontSize:(CGFloat)fontSize lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex {
  return [self withFont:[UIFont systemFontOfSize:fontSize] lines:lines x:x y:y w:w h:h flex:flex];
}


+ (id)withFontBoldSize:(CGFloat)fontSize lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex {
  return [self withFont:[UIFont boldSystemFontOfSize:fontSize] lines:lines x:x y:y w:w h:h flex:flex];
}


@end

