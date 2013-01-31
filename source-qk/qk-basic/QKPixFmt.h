// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


/* From Quartz 2D Programming Guide: Graphics Contexts
 ColorSpace, Bits per pixel, Bytes per component, Flags
 Null -   8 bpp,  8 bpc, kCGImageAlphaOnly - Mac OS X, iOS
 Gray -   8 bpp,  8 bpc, kCGImageAlphaNone - Mac OS X, iOS
 Gray -   8 bpp,  8 bpc, kCGImageAlphaOnly - Mac OS X, iOS
 Gray -  16 bpp, 16 bpc, kCGImageAlphaNone - Mac OS X
 Gray -  32 bpp, 32 bpc, kCGImageAlphaNone|kCGBitmapFloatComponents - Mac OS X
 RGB  -  16 bpp,  5 bpc, kCGImageAlphaNoneSkipFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaNoneSkipFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaNoneSkipLast - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaPremultipliedFirst - Mac OS X, iOS
 RGB  -  32 bpp,  8 bpc, kCGImageAlphaPremultipliedLast - Mac OS X, iOS
 RGB  -  64 bpp, 16 bpc, kCGImageAlphaPremultipliedLast - Mac OS X
 RGB  -  64 bpp, 16 bpc, kCGImageAlphaNoneSkipLast - Mac OS X
 RGB  - 128 bpp, 32 bpc, kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents - Mac OS X
 RGB  - 128 bpp, 32 bpc, kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents - Mac OS X
 CMYK -  32 bpp,  8 bpc, kCGImageAlphaNone - Mac OS X
 CMYK -  64 bpp, 16 bpc, kCGImageAlphaNone - Mac OS X
 CMYK - 128 bpp, 32 bpc, kCGImageAlphaNone|kCGBitmapFloatComponents - Mac OS X
 */

static const U32 QKPixFmtBitU8  = 1 << 0;
static const U32 QKPixFmtBitU16 = 1 << 1;
static const U32 QKPixFmtBitF32 = 1 << 2;
static const U32 QKPixFmtBitA   = 1 << 3; // alpha
static const U32 QKPixFmtBitX   = 1 << 4; // indicates skip fourth channel
static const U32 QKPixFmtBitL   = 1 << 5; // luminance (grayscale)
static const U32 QKPixFmtBitRGB = 1 << 6; // rgb

// OpenGL flags
static const U32 QKPixFmtBitD16 = 1 << 7; // 16 bit depth buffer
static const U32 QKPixFmtBitD24 = 1 << 8; // 24 bit depth buffer
static const U32 QKPixFmtBitMS4 = 1 << 9;   // 4 multisample
static const U32 QKPixFmtBitMS9 = 1 << 10;  // 9 multisample

typedef enum {
  QKPixFmtUnknown = 0,
  // alpha-only masks
  QKPixFmtAU8  = QKPixFmtBitA | QKPixFmtBitU8,
  QKPixFmtAU16 = QKPixFmtBitA | QKPixFmtBitU16,
  QKPixFmtAF32 = QKPixFmtBitA | QKPixFmtBitF32,
  // luminance (grayscale)
  QKPixFmtLU8    = QKPixFmtBitL | QKPixFmtBitU8,
  QKPixFmtLU16   = QKPixFmtBitL | QKPixFmtBitU16,
  QKPixFmtLF32   = QKPixFmtBitL | QKPixFmtBitF32,
  QKPixFmtLAU8   = QKPixFmtBitL | QKPixFmtBitA | QKPixFmtBitU8,
  QKPixFmtLAU16  = QKPixFmtBitL | QKPixFmtBitA | QKPixFmtBitU16,
  QKPixFmtLAF32  = QKPixFmtBitL | QKPixFmtBitA | QKPixFmtBitF32,
  // rgb
  QKPixFmtRGBU8    = QKPixFmtBitRGB | QKPixFmtBitU8,
  QKPixFmtRGBU16   = QKPixFmtBitRGB | QKPixFmtBitU16,
  QKPixFmtRGBF32   = QKPixFmtBitRGB | QKPixFmtBitF32,
  QKPixFmtRGBAU8   = QKPixFmtBitRGB | QKPixFmtBitA | QKPixFmtBitU8,
  QKPixFmtRGBAU16  = QKPixFmtBitRGB | QKPixFmtBitA | QKPixFmtBitU16,
  QKPixFmtRGBAF32  = QKPixFmtBitRGB | QKPixFmtBitA | QKPixFmtBitF32,
  QKPixFmtRGBXU8   = QKPixFmtBitRGB | QKPixFmtBitX | QKPixFmtBitU8,
  QKPixFmtRGBXU16  = QKPixFmtBitRGB | QKPixFmtBitX | QKPixFmtBitU16,
  QKPixFmtRGBXF32  = QKPixFmtBitRGB | QKPixFmtBitX | QKPixFmtBitF32,
} QKPixFmt;

NSString* QKPixFmtDesc(QKPixFmt format);
QKPixFmt QKPixFmtFromString(NSString* string);

int QKPixFmtBitsPerChannel(QKPixFmt format);
int QKPixFmtChannels(QKPixFmt format);
int QKPixFmtBytesPerPixel(QKPixFmt format);

int QKPixFmtBitmapInfo(QKPixFmt format);

int QKPixFmtGlDataFormat(QKPixFmt format);
int QKPixFmtGlDataType(QKPixFmt format);

int QKPixFmtDepth(QKPixFmt format);
int QKPixFmtMultisamples(QKPixFmt format);

