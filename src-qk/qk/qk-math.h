// Copyright 2008 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-types.h"
#import "qk-macros.h"


Int logstar(Int n);

// these return -1 for 0; 0x01 is bit 0
int highest_bit_64(U64 x);
int highest_bit_32(U32 x);
int lowest_bit_64(U64 x);
int lowest_bit_32(U32 x);


static inline int highest_bit(Uns x) {
  if (Int_is_64_bits) {
    return highest_bit_64(x);
  }
  else {
    return highest_bit_32(x);
  }
}


static inline int lowest_bit(Uns x) {
  if (Int_is_64_bits) {
    return lowest_bit_64(x);
  }
  else {
    return lowest_bit_32(x);
  }
}


static inline F64 degreesFromRadians(F64 radians) {
  return radians * 180.0 / M_PI;
}

static inline F64 radiansFromDegrees(F64 degrees) {
  return degrees * M_PI / 180.0;
}

static inline F64 modAngle(F64 angle) {
  return fmod(angle, 2 * M_PI);
}

static inline F64 lerp(F64 a, F64 b, F64 t) {
  return a + (b - a) * t;
}


static inline bool fuzzy_zero(F64 a, F64 epsilon) {
  return a <= epsilon && a >= -epsilon;
}


static inline bool fuzzy_eq(F64 a, F64 b, F64 epsilon) {
  return a <= b + epsilon && a >= b - epsilon;
}


static inline bool fuzzy_LT(F64 a, F64 b, F64 epsilon) {
  return a < b - epsilon;
}


static inline F64 mean2(F64 a, F64 b) {
  return (a + b) / 2;
}


static inline F64 mean3(F64 a, F64 b, F64 c) {
  return (a + b + c) / 3;
}


static inline F64 mean4(F64 a, F64 b, F64 c, F64 d) {
  return (a + b + c + d) / 4;
}


static inline int next_POT(Int x) {
  qk_assert(x >= 0, @"bad value: %ld", x);
  return 1 << (highest_bit(x) + 1);
}


static inline int min_POT_GT(int x) {
  return next_POT(x - 1);
}

