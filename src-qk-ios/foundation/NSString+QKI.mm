// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSString+QKI.h"


@implementation NSString (QKI)


+ (NSDictionary*)attributesForFont:(UIFont*)font
                         lineBreak:(NSLineBreakMode)lineBreak
                         alignment:(NSTextAlignment)alignment {
  NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
  style.lineBreakMode = lineBreak;
  style.alignment = alignment;
  return @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style};
}


- (CGSize)sizeForFont:(UIFont*)font
            lineBreak:(NSLineBreakMode)lineBreak
                    w:(CGFloat)w
                    h:(CGFloat)h {
  // note: NSLineBreakModeTruncating* modes indicate single line.
  CGRect r = [self boundingRectWithSize:CGSizeMake(w, h)
                                options:(lineBreak < NSLineBreakByTruncatingHead
                                         ? NSStringDrawingUsesLineFragmentOrigin
                                         : (NSStringDrawingOptions)0)
                             attributes:[NSString attributesForFont:font
                                                          lineBreak:lineBreak
                                                          alignment:NSTextAlignmentLeft]
                                context:nil];
  return CGSizeMake(ceil(r.size.height), ceil(r.size.width));
}


- (CGFloat)widthForFont:(UIFont*)font lineBreak:(NSLineBreakMode)lineBreak w:(CGFloat)w {
  qk_assert(lineBreak >= NSLineBreakByTruncatingHead, @"bad line break mode");
  CGSize s = [self sizeForFont:font lineBreak:lineBreak w:w h:font.lineHeight];
  return s.width;
}


- (CGFloat)heightForFont:(UIFont*)font
               lineBreak:(NSLineBreakMode)lineBreak
                       w:(CGFloat)w
                       h:(CGFloat)h
                 lineMin:(int)lineMin {
  qk_assert(lineMin >= 0, @"invalid lineMin: %d", lineMin);
  CGSize s = [self sizeForFont:font lineBreak:lineBreak w:w h:h];
  return MAX(font.lineHeight * lineMin, s.height);
}


- (CGFloat)heightForFont:(UIFont*)font
               lineBreak:(NSLineBreakMode)lineBreak
                       w:(CGFloat)w
                 lineMin:(int)lineMin
                 lineMax:(int)lineMax {
  qk_assert(lineMax >= lineMin, @"invalid lineMax: %d", lineMax);
  return [self heightForFont:font lineBreak:lineBreak w:w h:font.lineHeight * lineMax lineMin:lineMin];
}


- (void)drawInRect:(CGRect)rect
              font:(UIFont*)font
         lineBreak:(NSLineBreakMode)lineBreak
         alignment:(NSTextAlignment)alignment {
  [self drawInRect:rect
    withAttributes:[NSString attributesForFont:font
                                     lineBreak:lineBreak
                                     alignment:alignment]];
}


@end

