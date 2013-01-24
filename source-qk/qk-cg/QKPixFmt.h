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
static const U32 QKPixFmtBitA   = 1 << 3;
static const U32 QKPixFmtBitX   = 1 << 4; // indicates skip fourth channel
static const U32 QKPixFmtBitW   = 1 << 5;
static const U32 QKPixFmtBitRGB = 1 << 6;

typedef enum {
  QKPixFmtUnknown = 0,
  // alpha-only masks
  QKPixFmtAU8  = QKPixFmtBitA | QKPixFmtBitU8,
  QKPixFmtAU16 = QKPixFmtBitA | QKPixFmtBitU16,
  QKPixFmtAF32 = QKPixFmtBitA | QKPixFmtBitF32,
  // grayscale
  QKPixFmtWU8    = QKPixFmtBitW | QKPixFmtBitU8,
  QKPixFmtWU16   = QKPixFmtBitW | QKPixFmtBitU16,
  QKPixFmtWF32   = QKPixFmtBitW | QKPixFmtBitF32,
  QKPixFmtWAU8   = QKPixFmtBitW | QKPixFmtBitA | QKPixFmtBitU8,
  QKPixFmtWAU16  = QKPixFmtBitW | QKPixFmtBitA | QKPixFmtBitU16,
  QKPixFmtWAF32  = QKPixFmtBitW | QKPixFmtBitA | QKPixFmtBitF32,
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


int QKPixFmtBitsPerChannel(QKPixFmt format);
int QKPixFmtChannels(QKPixFmt format);
int QKPixFmtBitmapInfo(QKPixFmt format);
