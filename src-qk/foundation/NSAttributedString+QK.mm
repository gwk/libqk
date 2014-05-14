// Copyright 2014 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSAttributedString+QK.h"


NSMutableDictionary* strAttrs(CRFont* font,
                              CRColor* color,
                              NSTextAlignment align) {
  NSMutableDictionary* attrs = [NSMutableDictionary new];
  if (font) attrs[NSFontAttributeName] = font;
  if (color) attrs[NSForegroundColorAttributeName] = color;
  NSMutableParagraphStyle* s = [NSMutableParagraphStyle new];
  s.alignment = align;
  attrs[NSParagraphStyleAttributeName] = s;
  return attrs;
}


@implementation NSAttributedString (QK)


+ (instancetype)withString:(NSString*)string attrs:(NSDictionary*)attrs {
  return string ? [[self alloc] initWithString:string attributes:attrs] : nil;
}


@end

