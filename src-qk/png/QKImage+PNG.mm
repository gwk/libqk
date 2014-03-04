// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).
// Derived from readpng.c, which is licensed under the terms of libqk/license-readpng.txt.


#import <zlib.h>
#import <png.h>
#import "NSBundle+QK.h"
#import "NSData+QK.h"
#import "NSString+QK.h"
#import "QKErrorDomain.h"
#import "QKImage.h"
#import "QKImage+PNG.h"


@implementation QKImage (PNG)


+ (void)logPngVersionInfo {
  errFL(@"libpng compiled: %s; using: %s; zlib compiled: %s; using: %s",
        PNG_LIBPNG_VER_STRING, png_libpng_ver, ZLIB_VERSION, zlib_version);
}


// displayExponent == LUT_exponent * CRT_exponent
- (id)initWithPngReadPtr:(png_structp)readPtr
                 infoPtr:(png_infop)infoPtr
                   alpha:(BOOL)alpha
            gammaCorrect:(BOOL)gammaCorrect
         displayExponent:(F64)displayExponent
                    name:(NSString*)name
                   error:(NSError**)errorPtr {
    
  // setjmp() must be called prior to libng read function calls
#ifdef PNG_SETJMP_SUPPORTED
  CHECK_SET_ERROR_RET_NIL(!setjmp(png_jmpbuf(readPtr)), QK, ImagePNGRead, @"PNG read failed", @{
                          @"name" : name
                          });
#endif

  png_read_info(readPtr, infoPtr);

  png_uint_32 w, h;
  int srcBitDepth;
  int colorType;
  int interlaceType;
  int compressionType;
  int filterType;

  png_get_IHDR(readPtr, infoPtr, &w, &h, &srcBitDepth, &colorType, &interlaceType, &compressionType, &filterType);
  V2I32 size = V2I32Make(w, h);
  // we may alter this when selecting transforms below.
  BOOL srcHasRGB = colorType | PNG_COLOR_MASK_COLOR;
  BOOL srcHasAlpha = colorType | PNG_COLOR_MASK_ALPHA;
  
  // many options here; eventually we could allow for a target forrmat, but for now:
  // expand palette images to RGB, low-bit-depth grayscale images to 8 bits, transparency chunks to full alpha channel;
  // strip 16-bit-per-sample images to 8 bits per sample; and convert grayscale to RGB.
  int dstBitDepth = srcBitDepth;
  int dstHasRGB = srcHasRGB;
  int dstHasAlpha = srcHasAlpha;
  
  if (colorType == PNG_COLOR_TYPE_PALETTE) {
    png_set_expand(readPtr);
    dstBitDepth = 8;
  }
  if (colorType == PNG_COLOR_TYPE_GRAY && srcBitDepth < 8) {
    png_set_expand(readPtr);
    dstBitDepth = 8;
  }
  if (png_get_valid(readPtr, infoPtr, PNG_INFO_tRNS)) {
    png_set_expand(readPtr);
    dstBitDepth = 8;
  }
  if (srcBitDepth == 16) {
    png_set_strip_16(readPtr);
    dstBitDepth = 8;
  }
  if (colorType == PNG_COLOR_TYPE_GRAY || colorType == PNG_COLOR_TYPE_GRAY_ALPHA) {
    png_set_gray_to_rgb(readPtr);
    dstHasRGB = YES;
  }
  if (!alpha) {
    png_set_strip_alpha(readPtr);
    dstHasAlpha = NO;
  }
  
  QKPixFmt format = (QKPixFmt)((dstHasRGB ? QKPixFmtRGBU8 : QKPixFmtLU8) | (dstHasAlpha ? QKPixFmtBitA : QKPixFmtNone));
  // unlike the example in the libpng documentation, we have no idea where this file may have come from;
  // therefore if it does not have a file gamma, do not do any correction.
  double  gamma = 0;
  if (gammaCorrect && png_get_gAMA(readPtr, infoPtr, &gamma)) {
    png_set_gamma(readPtr, displayExponent, gamma);
  }
  
  // all transformations have been registered; update infoPtr
  png_read_update_info(readPtr, infoPtr);
  
  int channels = png_get_channels(readPtr, infoPtr);
  Int rowsLength = png_get_rowbytes(readPtr, infoPtr);
  CHECK_SET_ERROR_RET_NIL(rowsLength == size.v[0] * channels * dstBitDepth / 8,
                          QK, ImagePNGRowsLength, @"unexpected rows array byte length", @{
                          @"length" : @(rowsLength),
                          @"size" : V2I32Desc(size),
                          @"channels" : @(channels),
                          @"depth" : @(dstBitDepth),
                          });
  
  Int l =  rowsLength * size.v[1];
  NSMutableData* data = [NSMutableData dataWithCapacity:l];
  data.length = l;
  
  png_bytepp row_pointers = (png_bytepp)malloc(size.v[1] * sizeof(png_bytep));
  qk_check(row_pointers, @"malloc row_pointers failed");
  
  // fill out row_pointers
  const BOOL flip = YES; // make data layout match OpenGL texturing expectations.
  for_in(i, size.v[1]) {
    row_pointers[flip ? ((size.v[1] - 1) - i) : i] = (U8*)data.mutableBytes + i * rowsLength;
  }
  // read data
  png_read_image(readPtr, row_pointers);
  free(row_pointers);
  png_read_end(readPtr, NULL); // can be omitted if no processing of post-IDAT text/time/etc. is desired
  
  // get background color if available; currently unused so just print it
  if (0 && png_get_valid(readPtr, infoPtr, PNG_INFO_bKGD)) {
    // NOTE: png_get_bKGD takes a pointer to a pointer; always sets valid RGB values.
    // always returns raw bKGD data, regardless of any bit depth transformations.
    png_color_16p c;
    png_get_bKGD(readPtr, infoPtr, &c);
    
    // this always returns the raw bKGD data, regardless of any bit-depth transformations,
    // so check depth and adjust if necessary.
    V3U8 backgroundColor;
    if (srcBitDepth == 16) {
      backgroundColor = V3U8Make(c->red >> 8, c->green >> 8, c->blue >> 8);
    }
    else if (colorType == PNG_COLOR_TYPE_GRAY && srcBitDepth < 8) {
      U8 v;
      switch (srcBitDepth) {
        case 1: v = c->gray ? 0xFF : 0; break;
        case 2: v = (255/3) * c->gray;  break;
        case 4: v = (255/15) * c->gray; break;
        default:
          qk_fail(@"unexpected bit depth: %d", srcBitDepth);
      }
      backgroundColor = V3U8Make(v, v, v);
    }
    else {
      backgroundColor = V3U8Make(c->red, c->green, c->blue);
    }
    errFL(@"PNG backgroundColor: %@", V3U8Desc(backgroundColor));
  }
  return [self initWithFormat:format size:size data:data];
}


void qkpng_error_fn(png_structp png_ptr, png_const_charp error_msg) {
  auto static explanations =
  @{@"CgBI: unknown critical chunk" : @"The PNG file was most likely mangled by Xcode during iOS 'Copy Resources' build phase."
    };
  NSString* e = [explanations objectForKey:[NSString withUtf8:error_msg]];
  errFL(@"PNG error: %s", error_msg);
  if (e) {
    errL(e);
  }
}


//void qkpng_warning_fn(png_structp png_ptr, png_const_charp warning_msg) {}


- (id)initWithPngFile:(FILE*)file alpha:(BOOL)alpha name:(NSString*)name error:(NSError**)errorPtr {
  U8 sig[8];
  fread(sig, 1, 8, file);
  CHECK_SET_ERROR_RET_NIL(png_check_sig(sig, 8), QK, ImagePNGSignature, @"bad PNG signature", @{
                          @"name" : name
                          });
  png_voidp error_ptr = NULL;
  png_error_ptr warn_fn = NULL;
  png_structp readPtr = png_create_read_struct(PNG_LIBPNG_VER_STRING, error_ptr, qkpng_error_fn, warn_fn);
  qk_check(readPtr, @"png_create_read_struct failed (out of memory?)");
  png_infop infoPtr = png_create_info_struct(readPtr);
  qk_check(infoPtr, @"png_create_info_struct failed (out of memory?)");
  png_init_io(readPtr, file);
  png_set_sig_bytes(readPtr, 8); // since we already read the signature bytes
  
  self = [self initWithPngReadPtr:readPtr
                          infoPtr:infoPtr
                            alpha:alpha
                     gammaCorrect:NO
                  displayExponent:0
                             name:name
                            error:errorPtr];
  
  png_destroy_read_struct(&readPtr, &infoPtr, NULL);
  return self;
}


DEF_INIT(PngPath:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr) {
  // TODO: implement in-memory loading and mmap loading.
  FILE* file = fopen(path.asUtf8, "rb");
  CHECK_SET_ERROR_RET_NIL(file, QK, ImagePNGOpenFile, @"could not open file", @{
                          @"path" : path
                          });
  self = [self initWithPngFile:file alpha:alpha name:path error:errorPtr];
  fclose(file);
  return self;
}


+ (QKImage*)pngNamed:(NSString*)resourceName alpha:(BOOL)alpha {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  qk_check(path, @"no image named: %@", resourceName);
  NSError* e = nil;
  QKImage* i = [self withPngPath:path map:YES alpha:alpha error:&e];
  qk_check(i && !e, @"error loading image named: %@\n  %@", resourceName, e);
  return i;
}


@end

