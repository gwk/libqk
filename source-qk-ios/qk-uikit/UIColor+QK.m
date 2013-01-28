// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIColor+QK.h"


@implementation UIColor (QK)


+ (id)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
  return [self colorWithRed:r green:g blue:b alpha:a];
}


+ (id)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
  return [self colorWithRed:r green:g blue:b alpha:1];
}


+ (id)w:(CGFloat)l a:(CGFloat)a {
  return [self colorWithWhite:l alpha:a];
}


+ (id)w:(CGFloat)l {
  return [self colorWithWhite:l alpha:1];
}


#define GET_COLOR(c) \
- (CGFloat)c { \
CGFloat r, g, b, a; \
[self getRed:&r green:&g blue:&b alpha:&a]; \
return c; \
}


GET_COLOR(r);
GET_COLOR(g);
GET_COLOR(b);
GET_COLOR(a);


- (CGFloat)l {
  CGFloat l, a;
  [self getWhite:&l alpha:&a];
  return a;
}


@end

