// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UIImage+QK.h"
#import "qk-macros.h"


@implementation UIImage (QK)


+ (UIImage*)named:(NSString*)name {
    qk_assert(name, @"nil image name");    
    UIImage* image = [self imageNamed:name];
    qk_assert(image, @"no image for name: %@", name);
    return image;
}


+ (UIImage*)withColor:(UIColor *)color size:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  auto ctx = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(ctx, color.CGColor);
  CGContextFillRect(ctx, (CGRect){CGPointZero, size});
  auto image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}


+ (UIImage*)withColor:(UIColor*)color {
  return [self withColor:color size:CGSizeMake(1, 1)];
}


typedef uint8_t C8; // 8 bit color channel.

typedef struct {
  C8 r;
  C8 g;
  C8 b;
  C8 a;
} RGBA8;


- (UIImage*)lumImageOpaque {
  
  CGFloat scale = self.scale;
  auto cg_img_src = self.CGImage;
  auto cspace_src = CGImageGetColorSpace(cg_img_src);
  auto model = CGColorSpaceGetModel(cspace_src);
  switch (model) {
    case kCGColorSpaceModelMonochrome: return self;
    case kCGColorSpaceModelRGB: break;
    default: [NSException raise:@"UIImage lumImageOpaque" format:@"unexpected color space: %d", model];
  }
  int w = scale * self.size.width;
  int h = scale * self.size.height;
  
  // rgba image.
  auto ctx_rgba =
  CGBitmapContextCreate(NULL,
                        w, h,
                        8, w * sizeof(RGBA8),
                        cspace_src,
                        kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
  
  CGContextSetShouldAntialias(ctx_rgba, NO);
  CGContextDrawImage(ctx_rgba, CGRectMake(0, 0, w, h), cg_img_src);
  auto rgba = (RGBA8*)CGBitmapContextGetData(ctx_rgba);
  
  // luminance image.
  auto cspace_lum = CGColorSpaceCreateDeviceGray();
  auto ctx_lum = CGBitmapContextCreate(NULL,
                                  w, h,
                                  8, w * sizeof(C8),
                                  cspace_lum,
                                  kCGBitmapByteOrderDefault | kCGImageAlphaNone);

  CGColorSpaceRelease(cspace_lum);
  auto lum = (C8*)CGBitmapContextGetData(ctx_lum);
  
  // convert rgba to lum.
  RGBA8 *rgba_end = rgba + w * h;
  while (rgba < rgba_end) {
    // luminance weights from http://en.wikipedia.org/wiki/Grayscale
    float r = rgba->r * .3;
    float g = rgba->g * .59;
    float b = rgba->b * .11;
    uint32_t l = r + g + b;
    if (l > 0xFF) l = 0xFF;
    *lum++ = l;
    rgba++;
  }

  // create a UIImage.
  auto cg_img_lum = CGBitmapContextCreateImage(ctx_lum);
  CGContextRelease(ctx_rgba);
  CGContextRelease(ctx_lum);
  auto image = [UIImage imageWithCGImage:cg_img_lum scale:scale orientation:self.imageOrientation];
  CGImageRelease(cg_img_lum);
  return image;
}


@end
