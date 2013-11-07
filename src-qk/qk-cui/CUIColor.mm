// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CUIColor.h"

@implementation CUIColor (CUI)


+ (id)clear { return [self clearColor]; }
+ (id)w { return [self whiteColor]; }
+ (id)k { return [self blackColor]; }


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

#define RGBA(r, g, b, a) { return [self colorWithRed:r green:g blue:b alpha:a]; }

#define PRIMARY(n, c, r, g, b) \
+ (id)c { return [self n##Color]; } \
+ (id)c:(CGFloat)c RGBA(r, g, b, 1) \
+ (id)c:(CGFloat)c a:(CGFloat)a RGBA(r, g, b, a)

PRIMARY(red, r, r, 0, 0);
PRIMARY(green, g, 0, g, 0);
PRIMARY(blue, b, 0, 0, b);


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
