// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface NSString (QKI)

+ (NSDictionary*)attributesForFont:(UIFont*)font
                         lineBreak:(NSLineBreakMode)lineBreak
                         alignment:(NSTextAlignment)alignment;

- (CGSize)sizeForFont:(UIFont*)font
            lineBreak:(NSLineBreakMode)lineBreak
                    w:(CGFloat)w
                    h:(CGFloat)h;

- (CGFloat)widthForFont:(UIFont*)font lineBreak:(NSLineBreakMode)lineBreak w:(CGFloat)w;

- (CGFloat)heightForFont:(UIFont*)font
               lineBreak:(NSLineBreakMode)lineBreak
                       w:(CGFloat)w
                       h:(CGFloat)h
                 lineMin:(int)lineMin;

- (void)drawInRect:(CGRect)rect
              font:(UIFont*)font
         lineBreak:(NSLineBreakMode)lineBreak
         alignment:(NSTextAlignment)alignment;

@end

