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


+ (id)l:(CGFloat)l a:(CGFloat)a {
  return [self colorWithWhite:l alpha:a];
}


+ (id)l:(CGFloat)l {
  return [self colorWithWhite:l alpha:1];
}


+ (id)r:(CGFloat)r {
  return [self colorWithRed:r green:0 blue:0 alpha:1];
}


+ (id)g:(CGFloat)g {
  return [self colorWithRed:0 green:g blue:0 alpha:1];
}


+ (id)b:(CGFloat)b {
  return [self colorWithRed:0 green:0 blue:b alpha:1];
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

