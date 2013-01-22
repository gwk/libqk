// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKCGColorSpace.h"


@interface QKCGColorSpace ()
@end


@implementation QKCGColorSpace


CLASS_LAZY(QKCGColorSpace*, w,    [self withRetainedRef:CGColorSpaceCreateDeviceGray()]);
CLASS_LAZY(QKCGColorSpace*, rgb,  [self withRetainedRef:CGColorSpaceCreateDeviceRGB()]);

+ (QKCGColorSpace*)rgb:(BOOL)rgb {
  return rgb ? [self rgb] : [self w];
}


+ (QKCGColorSpace*)withFormat:(QKPixFmt)format {
  if (format & QKPixFmtBitRGB) {
    return [self rgb];
  }
  if (format & QKPixFmtBitW) {
    return [self w];
  }
  return nil; // mask format; no color space
}


@end

