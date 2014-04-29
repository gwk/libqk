// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#if TARGET_OS_IPHONE
#else
#import <OpenGL/gl3.h>
#endif


#import "qk-macros.h"
#import "QKPixFmt.h"


NSString* QKPixFmtDesc(QKPixFmt format) {
  switch (format) {
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, None);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, AU8);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, AU16);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, AF32);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, LU8);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, LU16);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, LF32);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, LAU8);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, LAU16);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, LAF32);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBU8);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBU16);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBF32);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBAU8);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBAU16);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBAF32);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBXU8);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBXU16);
      CASE_RET_TOK_SPLIT_STR(QKPixFmt, RGBXF32);
  }
  qk_fail(@"bad format: 0x%02X", format);
}


QKPixFmt QKPixFmtFromString(NSString* string) {
  // map two strings: bare, and prefixed
#define FI(fmt) @#fmt : @(QKPixFmt##fmt), @"QKPixFmt" @#fmt : @(QKPixFmt##fmt)
  static auto formats =
  @{FI(None),
    FI(AU8),
    FI(AU16),
    FI(AF32),
    FI(LU8),
    FI(LU16),
    FI(LF32),
    FI(LAU8),
    FI(LAU16),
    FI(LAF32),
    FI(RGBU8),
    FI(RGBU16),
    FI(RGBF32),
    FI(RGBAU8),
    FI(RGBAU16),
    FI(RGBAF32),
    FI(RGBXU8),
    FI(RGBXU16),
    FI(RGBXF32),
    };
#undef FI
  return (QKPixFmt)[[formats objectForKey:string] intValue];
}


Int QKPixFmtBitsPerChannel(QKPixFmt format) {
  if (format & QKPixFmtBitF32) {
    return 32;
  }
  if (format & QKPixFmtBitU16) {
    return 16;
  }
  qk_assert(format & QKPixFmtBitU8, @"bad format: %@", QKPixFmtDesc(format));
  return 8;
}


Int QKPixFmtChannels(QKPixFmt format) {
  Int comps = 0;
  if (format & QKPixFmtBitRGB) {
    comps = 3;
  }
  else if (format & QKPixFmtBitL) {
    comps = 1;
  }
  if (format & (QKPixFmtBitA | QKPixFmtBitX)) {
    comps += 1;
  }
  return comps;
}


Int QKPixFmtBitsPerPixel(QKPixFmt format) {
  return QKPixFmtBitsPerChannel(format) * QKPixFmtChannels(format);
}


Int QKPixFmtBytesPerPixel(QKPixFmt format) {
  Int bpp = QKPixFmtBitsPerPixel(format);
  qk_assert(bpp % 8 == 0, @"irregular bits per pixel: %ld", bpp);
  return bpp / 8;
}


CGBitmapInfo QKPixFmtBitmapInfo(QKPixFmt format) {
  CGBitmapInfo info;
  if (format & (QKPixFmtBitL | QKPixFmtBitRGB)) {
    if (format & QKPixFmtBitA) {
      info = kCGImageAlphaPremultipliedLast;
    }
    else if (format & QKPixFmtBitX) {
      info = kCGImageAlphaNoneSkipLast;
    }
    else {
      info = kCGImageAlphaNone;
    }
  }
  else if (format & QKPixFmtBitA) {
    info = kCGImageAlphaOnly;
  }
  else {
    qk_fail(@"bad format: %@", QKPixFmtDesc(format));
  }
  if (format & QKPixFmtBitF32) {
    info |= kCGBitmapFloatComponents;
  }
  return info;
}


// OpenGLES 3.0 dataFormat must be one of:
// GL_RED, GL_RED_INTEGER, GL_RG, GL_RG_INTEGER, GL_RGB, GL_RGB_INTEGER, GL_RGBA, GL_RGBA_INTEGER, GL_ALPHA,
// GL_DEPTH_COMPONENT, GL_DEPTH_STENCIL, GL_LUMINANCE_ALPHA, GL_LUMINANCE.

GLenum QKPixFmtGlDataFormat(QKPixFmt format) {
  switch (format) {
    case QKPixFmtRGBU8: return GL_RGB;
    case QKPixFmtRGBAU8: return GL_RGBA;
    default:
      qk_fail(@"pixel format is not mapped to OpenGL data format: %@", QKPixFmtDesc(format));
  }
}


// OpenGLES 3.0 dataType must be one of:
// GL_UNSIGNED_BYTE, GL_BYTE, GL_UNSIGNED_SHORT, GL_SHORT, GL_UNSIGNED_INT, GL_INT, GL_HALF_FLOAT, GL_FLOAT,
// GL_UNSIGNED_SHORT_5_6_5, GL_UNSIGNED_SHORT_4_4_4_4, GL_UNSIGNED_SHORT_5_5_5_1,
// GL_UNSIGNED_INT_2_10_10_10_REV, GL_UNSIGNED_INT_10F_11F_11F_REV, GL_UNSIGNED_INT_5_9_9_9_REV,
// GL_UNSIGNED_INT_24_8, GL_FLOAT_32_UNSIGNED_INT_24_8_REV.

GLenum QKPixFmtGlDataType(QKPixFmt format) {
  switch (format) {
    case QKPixFmtRGBU8:
    case QKPixFmtRGBAU8: return GL_UNSIGNED_BYTE;
    default:
      qk_fail(@"pixel format is not mapped to OpenGL data type: %@", QKPixFmtDesc(format));
  }
}


Int QKPixFmtColorSize(QKPixFmt format) {
  if (format & (QKPixFmtBitL | QKPixFmtBitRGB)) {
    return QKPixFmtBitsPerChannel(format);
  }
  return 0;
}


Int QKPixFmtAlphaSize(QKPixFmt format) {
  if (format & QKPixFmtBitA) {
    return QKPixFmtBitsPerChannel(format);
  }
  return 0;
}


Int QKPixFmtDepthSize(QKPixFmt format) {
  if (format & QKPixFmtBitD16) return 16;
  if (format & QKPixFmtBitD24) return 24;
  return 0;
}


Int QKPixFmtMultisamples(QKPixFmt format) {
  if (format & QKPixFmtBitMS4) return 4;
  if (format & QKPixFmtBitMS9) return 9;
  return 0;
}


CGColorSpaceRef QKPixFmtCreateCGColorSpace(QKPixFmt format) {
  if (format & QKPixFmtBitRGB) return CGColorSpaceCreateDeviceRGB();
  if (format & QKPixFmtBitL) return CGColorSpaceCreateDeviceGray();
  return NULL;
}


#if LIB_JPG_AVAILABLE
TJPF QKPixFmtTJPF(QKPixFmt format) {
  switch (format) {
    case QKPixFmtLU8: return TJPF_GRAY;
    case QKPixFmtRGBU8: return TJPF_RGB;
    case QKPixFmtRGBAU8: return TJPF_RGBA;
    case QKPixFmtRGBXU8: return TJPF_RGBX;
    default:
      qk_fail(@"no jpg format for QKPixFmt: %@", QKPixFmtDesc(format));
  }
}
#endif

