// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSString+QKM.h"


@implementation NSString (QKM)


- (CGFloat)widthForFont:(UIFont*)font w:(CGFloat)w lineBreak:(NSLineBreakMode)lineBreak {
  CGSize s = [self sizeWithFont:font forWidth:w lineBreakMode:lineBreak];
  return s.width;
}


- (CGFloat)heightForFont:(UIFont*)font
                       w:(CGFloat)w
                       h:(CGFloat)h
               lineBreak:(UILineBreakMode)lineBreak
                 lineMin:(int)lineMin {
  
  CGSize s = [self sizeWithFont:font constrainedToSize:CGSizeMake(w, h) lineBreakMode:lineBreak];
  return MAX(font.lineHeight * lineMin, s.height);
}


- (CGFloat)heightForFont:(UIFont*)font
                       w:(CGFloat)w
               lineBreak:(UILineBreakMode)lineBreak
                 lineMin:(int)lineMin
                 lineMax:(int)lineMax {
  
  qk_assert(lineMin >= 0 && lineMax > 0 && lineMin <= lineMax, @"invalid line min/max: %d, %d", lineMin, lineMax);
  CGFloat h = font.lineHeight * lineMax;
  CGSize s = [self sizeWithFont:font constrainedToSize:CGSizeMake(w, h) lineBreakMode:lineBreak];
  return MAX(font.lineHeight * lineMin, s.height);
}



@end

