// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <stdint.h>
#import <stdbool.h>


#if TARGET_OS_IPHONE
typedef int32_t Int;
typedef uint32_t Uns;
#else
typedef int64_t Int;
typedef uint64_t Uns;
#endif


typedef int16_t I16;
typedef uint16_t U16;

typedef int32_t I32;
typedef uint32_t U32;

typedef float F32;
typedef double F64;

typedef const char* Ascii;
typedef const char* Utf8;
typedef const wchar_t* Utf32;

typedef char* AsciiM;
typedef char* Utf8M;
typedef wchar_t* Utf32M;


#define TYPEDEF_V2(el_type) \
typedef struct { el_type _[2]; } V2##el_type; \
static inline V2##el_type V2##el_type##Make(el_type x, el_type y) {\
V2##el_type v = { { x, y } }; \
return v; }


#define TYPEDEF_V3(el_type) \
typedef struct { el_type _[3]; } V3##el_type; \
static inline V3##el_type V3##el_type##Make(el_type x, el_type y, el_type z) {\
V3##el_type v = { { x, y, z } }; \
return v; }


TYPEDEF_V2(U16);
TYPEDEF_V2(I32);
TYPEDEF_V2(F32);

TYPEDEF_V3(U16);
TYPEDEF_V3(I32);
TYPEDEF_V3(F32);


typedef V2U16 Seg;
typedef V3U16 Tri;
