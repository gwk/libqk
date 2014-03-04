// Copyright 2008 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-math.h"


Int logstar(Int n) {
  Int i;
  double v;
  for (i = 0, v = n; v >= 1; i++) {
    v = log2(v);
  }
  return i - 1;
}


// returns -1 for 0; 0x01 is bit 0
int highest_bit_64(U64 x) {
  
  int base = 0;
  
  if (x & 0xFFFFFFFF00000000ULL) {
    base = 32;
    x >>= 32;
  }
  if (x & 0xFFFF0000ULL) {
    base += 16;
    x >>= 16;
  }
  if (x & 0xFF00ULL) {
    base += 8;
    x >>= 8;
  }
  if (x & 0xF0ULL) {
    base += 4;
    x >>= 4;
  }
  
  static const int lut[16] = {-1,0,1,1,2,2,2,2,3,3,3,3,3,3,3,3};
  return base + lut[x];
}


// returns -1 for 0; 0x01 is bit 0
int highest_bit_32(U32 x) {
  
  int base = 0;
  
  if (x & 0xFFFF0000U) {
    base += 16;
    x >>= 16;
  }
  if (x & 0xFF00U) {
    base += 8;
    x >>= 8;
  }
  if (x & 0xF0U) {
    base += 4;
    x >>= 4;
  }
  
  static const int lut[16] = {-1,0,1,1,2,2,2,2,3,3,3,3,3,3,3,3};
  return base + lut[x];
}


// returns -1 for 0; 0x01 is bit 0
int lowest_bit_64(U64 x) {
  
  if (x == 0) return -1;
  
  int base = 0;
  
  if (!(x & 0x00000000FFFFFFFFULL)) {
    base = 32;
    x >>= 32;
  }
  if (!(x & 0x0000FFFFULL))    {
    base += 16;
    x >>= 16;
  }
  if (!(x & 0x000000FFULL)) {
    base += 8;
    x >>= 8;
  }
  if (!(x & 0x0000000FULL)) {
    base += 4;
    x >>= 4;
  }
  
  static const int lut[16] = {4,0,1,0,2,0,1,0,3,0,1,0,2,0,1,0};
  return base + lut[x % 16];
}


// returns -1 for 0; 0x01 is bit 0
int lowest_bit_32(U32 x) {
  
  if (x == 0) return -1;
  
  int base = 0;
  
  if (!(x & 0xFFFFU)) {
    base += 16;
    x >>= 16;
  }
  if (!(x & 0xFFU)) {
    base += 8;
    x >>= 8;
  }
  if (!(x & 0x0FU)) {
    base += 4;
    x >>= 4;
  }
  
  static const int lut[16] = {4,0,1,0,2,0,1,0,3,0,1,0,2,0,1,0};
  return base + lut[x % 16];
}
