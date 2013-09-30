// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"


@interface NSString (QKM)


- (CGFloat)widthForFont:(UIFont*)font w:(CGFloat)w lineBreak:(NSLineBreakMode)lineBreak;

- (CGFloat)heightForFont:(UIFont*)font
                       w:(CGFloat)w
                       h:(CGFloat)h
               lineBreak:(NSLineBreakMode)lineBreak
                 lineMin:(int)lineMin;

- (CGFloat)heightForFont:(UIFont*)font
                       w:(CGFloat)w
               lineBreak:(NSLineBreakMode)lineBreak
                 lineMin:(int)lineMin
                 lineMax:(int)lineMax;

@end

