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
