// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKCGColorSpace.h"


@interface QKCGColorSpace ()
@end


@implementation QKCGColorSpace


LAZY_STATIC_METHOD(QKCGColorSpace*, w,    [self withRetainedRef:CGColorSpaceCreateDeviceGray()]);
LAZY_STATIC_METHOD(QKCGColorSpace*, rgb,  [self withRetainedRef:CGColorSpaceCreateDeviceRGB()]);

+ (QKCGColorSpace*)rgb:(BOOL)rgb {
  return rgb ? [self rgb] : [self w];
}


+ (QKCGColorSpace*)withFormat:(QKPixFmt)format {
  if (format & QKPixFmtBitRGB) {
    return [self rgb];
  }
  if (format & QKPixFmtBitL) {
    return [self w];
  }
  return nil; // mask format; no color space
}


@end

