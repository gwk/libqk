// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.
// Derived from readpng.c, which is licensed under the terms of libqk/license-readpng.txt.

#import "png.h"
#import "zlib.h"
#import "PNGImage.h"


@interface PNGImage ()

@property (nonatomic) NSMutableData* mutableData;

@end


@implementation PNGImage


+ (void)logVersionInfo {
  errFL(@"libpng compiled: %s; using: %s; zlib compiled: %s; using: %s",
        PNG_LIBPNG_VER_STRING, png_libpng_ver, ZLIB_VERSION, zlib_version);
}


- (NSString*)description {
  return [NSString withFormat:
          @"<%@ %p: s:%@ c:%d(%@%@) depth:%d clr:%d inter:%d comp:%d filt:%d rbs:%ld",
          self.class, self,
          V2I32Desc(_size),
          _channels, (_hasRGB ? @"RGB" : @"W"), (_hasAlpha ? @"A" : @""),
          _bitDepth, _colorType, _interlaceType, _compressionType, _filterType, _rowByteSize];
}


// displayExponent == LUT_exponent * CRT_exponent
- (id)initWithReadPtr:(png_structp)readPtr
              infoPtr:(png_infop)infoPtr
                alpha:(BOOL)alpha
         gammaCorrect:(BOOL)gammaCorrect
      displayExponent:(F64)displayExponent {
  
  INIT(super init);
  
  // setjmp() must be called prior to libng read function calls
#ifdef PNG_SETJMP_SUPPORTED
  if (setjmp(png_jmpbuf(readPtr))) {
    fail(@"PNG read failed");
    return nil;
  }
#endif
  
  png_set_sig_bytes(readPtr, 8); // since we already read the signature bytes
  png_read_info(readPtr, infoPtr);
  
  png_uint_32 w, h;
  int original_depth;
  png_get_IHDR(readPtr, infoPtr, &w, &h, &original_depth, &_colorType, &_interlaceType, &_compressionType, &_filterType);
  _size = V2I32Make(w, h);
  // we may alter this when selecting transforms below.
  _bitDepth = original_depth;
  _hasRGB = _colorType | PNG_COLOR_MASK_COLOR;
  _hasAlpha = _colorType | PNG_COLOR_MASK_ALPHA;
    
  // expand palette images to RGB, low-bit-depth grayscale images to 8 bits, transparency chunks to full alpha channel;
  // strip 16-bit-per-sample images to 8 bits per sample; and convert grayscale to RGB[A].
  
  if (_colorType == PNG_COLOR_TYPE_PALETTE) {
    png_set_expand(readPtr);
    _bitDepth = 8;
  }
  if (_colorType == PNG_COLOR_TYPE_GRAY && _bitDepth < 8) {
    png_set_expand(readPtr);
    _bitDepth = 8;
  }
  if (png_get_valid(readPtr, infoPtr, PNG_INFO_tRNS)) {
    png_set_expand(readPtr);
    _bitDepth = 8;
  }
  if (_bitDepth == 16) {
    png_set_strip_16(readPtr);
    _bitDepth = 8;
  }
  if (_colorType == PNG_COLOR_TYPE_GRAY || _colorType == PNG_COLOR_TYPE_GRAY_ALPHA) {
    png_set_gray_to_rgb(readPtr);
    _hasRGB = YES;
  }
  if (!alpha) {
    png_set_strip_alpha(readPtr);
    _hasAlpha = NO;
  }
  
  // unlike the example in the libpng documentation, we have no idea where this file may have come from;
  // therefore if it does not have a file gamma, do not do any correction.
  double  gamma = 0;
  if (gammaCorrect && png_get_gAMA(readPtr, infoPtr, &gamma)) {
    png_set_gamma(readPtr, displayExponent, gamma);
  }
  
  // all transformations have been registered;
  // now update infoPtr data, get rowbytes and channels, and allocate image memory
  png_read_update_info(readPtr, infoPtr);
  
  _channels = png_get_channels(readPtr, infoPtr);
  _rowByteSize = png_get_rowbytes(readPtr, infoPtr);
  check(_rowByteSize == _size._[0] * _channels * _bitDepth / 8,
        @"unexpected rowByteSize: %ld; size: %@; channels: %d; depth: %d",
        _rowByteSize, V2I32Desc(_size), _channels, _bitDepth);
  
  Int l =  _rowByteSize * _size._[1];
  _mutableData = [NSMutableData dataWithCapacity:l];
  _mutableData.length = l;
  
  png_bytepp row_pointers = malloc(_size._[1] * sizeof(png_bytep));
  check(row_pointers, @"malloc row_pointers failed");
  
  // fill out row_pointers
  const BOOL flip = YES; // make data layout match OpenGL texturing expectations.
  for_in(i, _size._[1]) {
    row_pointers[flip ? ((_size._[1] - 1) - i) : i] = _mutableData.mutableBytes + i * _rowByteSize;
  }
  // read data
  png_read_image(readPtr, row_pointers);
  free(row_pointers);
  png_read_end(readPtr, NULL); // can be omitted if no processing of post-IDAT text/time/etc. is desired
    
  // get background color if available
  if (png_get_valid(readPtr, infoPtr, PNG_INFO_bKGD)) {
    // NOTE: png_get_bKGD takes a pointer to a pointer; always sets valid RGB values.
    // always returns raw bKGD data, regardless of any bit depth transformations.
    png_color_16p c;
    png_get_bKGD(readPtr, infoPtr, &c);
    
    // this always returns the raw bKGD data, regardless of any bit-depth transformations;
    // so check depth and adjust if necessary
    if (original_depth == 16) {
      _backgroundColor = V3U8Make(c->red >> 8, c->green >> 8, c->blue >> 8);
    }
    else if (_colorType == PNG_COLOR_TYPE_GRAY && original_depth < 8) {
      U8 v;
      switch (original_depth) {
        case 1: v = c->gray ? 0xFF : 0; break;
        case 2: v = (255/3) * c->gray;  break;
        case 4: v = (255/15) * c->gray; break;
        default:
          fail(@"unexpected bit depth: %d", original_depth);
      }
      _backgroundColor = V3U8Make(v, v, v);
    }
    else {
      _backgroundColor = V3U8Make(c->red, c->green, c->blue);
    }
  }
  return self;
}


void qkpng_error_fn(png_structp png_ptr, png_const_charp error_msg) {
  LAZY_STATIC(NSDictionary*, explanations, @{
              @"CgBI: unknown critical chunk" : @"The png file was most likely mangled by during iOS copy resources build phase."
              });
  NSString* e = [explanations objectForKey:[NSString withUtf8:error_msg]];
  errFL(@"PNG error: %s", error_msg);
  if (e) {
    errL(e);
  }
}

void qkpng_warning_fn(png_structp png_ptr,
                     png_const_charp warning_msg);

- (id)initWithFile:(FILE*)file alpha:(BOOL)alpha {
  U8 sig[8];
  fread(sig, 1, 8, file);
  if (!png_check_sig(sig, 8)) {
    errFL(@"bad png signature");
    return nil;
  }
  
  png_voidp error_ptr = NULL;
  png_error_ptr warn_fn = NULL;
  png_structp readPtr = png_create_read_struct(PNG_LIBPNG_VER_STRING, error_ptr, qkpng_error_fn, warn_fn);
  check(readPtr, @"png_create_read_struct failed (out of memory?)");
  png_infop infoPtr = png_create_info_struct(readPtr);
  check(infoPtr, @"png_create_info_struct failed (out of memory?)");
  png_init_io(readPtr, file);
  self = [self initWithReadPtr:readPtr infoPtr:infoPtr alpha:alpha gammaCorrect:NO displayExponent:0];
  png_destroy_read_struct(&readPtr, &infoPtr, NULL);
  return self;
}



- (id)initWithPath:(NSString*)path alpha:(BOOL)alpha {
  FILE* file = fopen(path.asUtf8, "rb");
  check(file, @"could not open file: %@", path);
  return [self initWithFile:file alpha:alpha];
}


+ (PNGImage*)named:(NSString*)resourceName alpha:(BOOL)alpha {
  NSString* path = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil];
  check(path, @"no image named: %@", resourceName);
  return [[self alloc] initWithPath:path alpha:alpha];
}


- (NSData*)data {
  return _mutableData;
}


@end

