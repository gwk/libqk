// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"


@interface NSString (QKM)


- (CGSize)sizeForFont:(UIFont*)font
                 size:(CGSize)size
            lineBreak:(UILineBreakMode)lineBreak
              lineMin:(int)lineMin;

- (CGFloat)heightForFont:(UIFont*)font
                       w:(CGFloat)w
                       h:(CGFloat)h
               lineBreak:(UILineBreakMode)lineBreak
                 lineMin:(int)lineMin;
  
@end

