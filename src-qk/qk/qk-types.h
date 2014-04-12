// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <stdint.h>
#import <stdbool.h>


#define Int_is_64_bits (sizeof(long) == 8)

typedef long Int;
typedef unsigned long Uns;

#if TARGET_OS_IPHONE
typedef float Flt;
#else
typedef double Flt;
#endif

typedef char I8;
typedef unsigned char U8;

typedef int16_t I16;
typedef uint16_t U16;

typedef int32_t I32;
typedef uint32_t U32;

typedef int64_t I64;
typedef uint64_t U64;

typedef float F32;
typedef double F64;

typedef const char* Ascii;
typedef const char* Utf8;
typedef const wchar_t* Utf32;

typedef char* AsciiM;
typedef char* Utf8M;
typedef wchar_t* Utf32M;

static const Int min_Int = LONG_MIN;
static const Int max_Int = LONG_MAX;
static const Uns max_Uns = ULONG_MAX;
static const I8 min_I8 = SCHAR_MIN;
static const I8 max_I8 = SCHAR_MAX;
static const U8 max_U8 = UCHAR_MAX;
static const I16 min_I16 = SHRT_MIN;
static const I16 max_I16 = SHRT_MAX;
static const U16 max_U16 = USHRT_MAX;
static const I32 min_I32 = INT_MIN;
static const I32 max_I32 = INT_MAX;
static const U32 max_U32 = UINT_MAX;
static const I64 min_I64 = LLONG_MIN;
static const I64 max_I64 = LLONG_MAX;
static const U64 max_U64 = ULLONG_MAX;
