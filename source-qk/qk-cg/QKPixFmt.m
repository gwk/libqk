// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKPixFmt.h"



int QKPixFmtBitsPerChannel(QKPixFmt format) {
  if (format & QKPixFmtBitF32) {
    return 32;
  }
  if (format & QKPixFmtBitU16) {
    return 16;
  }
  assert(format & QKPixFmtBitU8, @"bad format: 0x%X", format);
  return 8;
}


int QKPixFmtChannels(QKPixFmt format) {
  int comps = 0;
  if (format & QKPixFmtBitRGB) {
    comps = 3;
  }
  else if (format & QKPixFmtBitW) {
    comps = 1;
  }
  if (format & (QKPixFmtBitA | QKPixFmtBitX)) {
    comps += 1;
  }
  return comps;
}


int QKPixFmtBitmapInfo(QKPixFmt format) {
  CGBitmapInfo info;
  if (format & (QKPixFmtBitW | QKPixFmtBitRGB)) {
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
    fail(@"bad format: 0x%X", format);
  }
  if (format & QKPixFmtBitF32) {
    info |= kCGBitmapFloatComponents;
  }
  return info;
}

