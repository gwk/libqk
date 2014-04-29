// Copyright 2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import <GLKit/GLKit.h>

#import "qk-types.h"
#import "qk-macros.h"
#import "qk-math.h"


// alias the GLK vector and matrix types to be shorter; add additional, similarly structured types for other scalar types.
// the naming convention is VDT, where D is the dimension (e.g. '2'), and T is the scalar element type, (e.g. 'F32').
// we make use of C compound literals, which look like type-casts of array literals (e.g, '(V2F32) { { 0, 0 } }').
// this has the advantage that unspecified fields are zero-initialized,
// which allows for generic conversions between dimensions.
/*
#ifndef QK_USE_GLK
# ifdef __GLK_MATH_TYPES_H
#warning "use glk"
#   define QK_USE_GLK 1
# else
#   define QK_USE_GLK 0
# endif
#endif
*/
#define QK_USE_GLK 1

// vector functions for all types (aliases and locally defined).
#define _V_FNS(TE, TV, dim) \
\
static const TV TV##Zero = (TV) {{}}; \
\
static inline F64 TV##Aspect(TV v, TE eps) { \
return (v.v[0] < eps || v.v[1] < eps) ? 0 : (F64)v.v[0] / (F64)v.v[1]; } \
\
static inline TE TV##Measure(TV v) { TE m = 1; for_in(i, dim) m *= v.v[i]; return m; } \
\
static inline BOOL TV##LT(TV a, TV b) { \
for_in(i, dim) { if (a.v[i] < b.v[i]) return YES; if (a.v[i] > b.v[i]) return NO; } return NO; } \
\
static inline BOOL TV##LTRev(TV a, TV b) { \
for_in_rev(i, dim) { if (a.v[i] < b.v[i]) return YES; if (a.v[i] > b.v[i]) return NO; } return NO; } \
\
static inline TV TV##WithCGPoint(CGPoint p) { return (TV) {{ (TE)p.x, (TE)p.y }}; } \
\
static inline TV TV##WithCGSize(CGSize s) { return (TV) {{ (TE)s.width, (TE)s.height }}; } \
\
static inline CGPoint CGPointWith##TV(TV v) { return CGPointMake(v.v[0], v.v[1]); } \
\
static inline CGSize CGSizeWith##TV(TV v) { return CGSizeMake(v.v[0], v.v[1]); } \
\
static inline TV TV##Mean(TV a, TV b) { return TV##Div(TV##Add(a, b), 2); } \



#define _V_FNS_LOCAL(TE, TV, dim) \
\
static inline TV TV##Neg(TV v) { TV r; for_in(i, dim) r.v[i] = -v.v[i]; return r; } \
\
static inline TV TV##Add(TV a, TV b) { TV r; for_in(i, dim) r.v[i] = a.v[i] + b.v[i]; return r; } \
static inline TV TV##Sub(TV a, TV b) { TV r; for_in(i, dim) r.v[i] = a.v[i] - b.v[i]; return r; } \
\
static inline TV TV##Mul(TV v, TE s) { TV r; for_in(i, dim) r.v[i] = v.v[i] * s; return r; } \
static inline TV TV##Div(TV v, TE s) { TV r; for_in(i, dim) r.v[i] = v.v[i] / s; return r; } \
\
static inline TV TV##MulVec(TV a, TV b) { TV r; for_in(i, dim) r.v[i] = a.v[i] * b.v[i]; return r; } \
static inline TV TV##DivVec(TV a, TV b) { TV r; for_in(i, dim) r.v[i] = a.v[i] / b.v[i]; return r; } \
\
static inline TV TV##Lerp(TV a, TV b, F64 t) { \
TV r; for_in(i, dim) r.v[i] = lerp(a.v[i], b.v[i], t); return r; }\



#define _V_FNS_ALIASED(TE, TV, dim) \
\
static inline TV TV##Neg(TV v) { return GLKVector##dim##Negate(v); } \
\
static inline TV TV##Add(TV a, TV b) { return GLKVector##dim##Add(a, b); } \
static inline TV TV##Sub(TV a, TV b) { return GLKVector##dim##Subtract(a, b); } \
\
static inline TV TV##Mul(TV v, TE s) { return GLKVector##dim##MultiplyScalar(v, s); } \
static inline TV TV##Div(TV v, TE s) { return GLKVector##dim##DivideScalar(v, s); } \
\
static inline TV TV##MulVec(TV a, TV b) { return GLKVector##dim##Multiply(a, b); } \
static inline TV TV##DivVec(TV a, TV b) { return GLKVector##dim##Divide(a, b); } \
\
static inline TV TV##Lerp(TV a, TV b, F64 t) { return GLKVector##dim##Lerp(a, b, t); } \



#define _V_FNS_F(dim, TV) \
\
static inline TV TV##Inv(TV v) { TV r; for_in(i, dim) r.v[i] = 1.0 / v.v[i]; return r; } \


#define _V_FNS_F_LOCAL(dim, TV) \
_V_FNS_F(dim, TV) \
\
static inline F64 TV##Dot(TV a, TV b) { F64 d = 0; for_in(i, dim) d += a.v[i] * b.v[i]; return d; } \
\
static inline F64 TV##Mag(TV v) { return sqrt(TV##Dot(v, v)); } \
\
static inline F64 TV##Dist(TV a, TV b) { return TV##Mag(TV##Sub(a, b)); } \
\
static inline TV TV##Norm(TV v) { return TV##Div(v, TV##Mag(v)); } \


// note precision changes to match native functions.
#define _V_FNS_F_ALIASED(dim, TV) \
_V_FNS_F(dim, TV) \
\
static inline F32 TV##Dot(TV a, TV b) { return GLKVector##dim##DotProduct(a, b); } \
\
static inline F32 TV##Mag(TV v) { return GLKVector##dim##Length(v); } \
\
static inline F32 TV##Dist(TV a, TV b) { return GLKVector##dim##Distance(a, b); } \
\
static inline TV TV##Norm(TV v) { return GLKVector##dim##Normalize(v); } \


#define _V_FNS_2(TE, TV, fmt) \
\
static const TV TV##Unit = (TV) {{ 1, 1 }}; \
\
static inline TV TV##Make(TE x, TE y) { return (TV) {{ x, y }}; } \
\
static inline NSString* TV##Desc(TV v) { \
return [NSString stringWithFormat:@"(" fmt @" " fmt @")", v.v[0], v.v[1]]; } \
\
static inline TV TV##UpdateRange(TV r, TE v) { \
return (TV) {{ (v < r.v[0] ? v : r.v[0]), (v > r.v[1] ? v : r.v[1]) }}; \
}


#define _V_FNS_3(TE, TV, fmt) \
\
static const TV TV##Unit = (TV) {{ 1, 1, 1 }}; \
\
static inline TV TV##Make(TE x, TE y, TE z) { return (TV) {{ x, y, z }}; } \
\
static inline NSString* TV##Desc(TV v) { \
return [NSString stringWithFormat:@"(" fmt @" " fmt @" " fmt @")", v.v[0], v.v[1], v.v[2]]; } \


#define _V_FNS_4(TE, TV, fmt) \
\
static const TV TV##Unit = (TV) {{ 1, 1, 1, 1 }}; \
\
static inline TV TV##Make(TE x, TE y, TE z, TE w) { return (TV) {{ x, y, z, w }}; } \
\
static inline NSString* TV##Desc(TV v) { \
return [NSString stringWithFormat:@"(" fmt @" " fmt @" " fmt @" " fmt @")", v.v[0], v.v[1], v.v[2], v.v[3]]; } \


#define _DEF_V(dim, TE, fmt) \
typedef struct { TE v[dim]; } V##dim##TE; \
_V_FNS_LOCAL(TE, V##dim##TE, dim); \
_V_FNS(TE, V##dim##TE, dim); \
_V_FNS_##dim(TE, V##dim##TE, fmt); \

#define _DEF_V_ALIASED(dim, TE, fmt) \
_V_FNS_ALIASED(TE, V##dim##TE, dim); \
_V_FNS(TE, V##dim##TE, dim); \
_V_FNS_##dim(TE, V##dim##TE, fmt); \


#define _DEF_V_F_WITH_I_EXP(dim, TF, TI, TVF, TVI) \
static inline TVF TVF##With##TI(TVI v) { \
TVF r; for_in(i ,dim) r.v[i] = v.v[i]; \
return r; } \
\
static inline TVF TVF##With##TI##Scaled(TVI v, F64 scale) { \
TVF r; for_in(i ,dim) r.v[i] = v.v[i] / scale; \
return r; } \

#define _DEF_V_F_WITH_I(dim, TF, TI) \
_DEF_V_F_WITH_I_EXP(dim, TF, TI, V##dim##TF, V##dim##TI)


#define _DEF_TVA_WITH_TVB(dim, TVA, TVB) \
static inline TVA TVA##With##TVB(TVB v) { \
TVA r; for_in(i ,dim) r.v[i] = v.v[i]; \
return r; } \


#if QK_USE_GLK
#if defined(__STRICT_ANSI__)
#error "GLKit vector types are not unions due to __STRICT_ANSI__ being defined."
#endif
typedef GLKVector2 V2F32;
typedef GLKVector3 V3F32;
typedef GLKVector4 V4F32;
_DEF_V_ALIASED(2, F32, @"% f");
_DEF_V_ALIASED(3, F32, @"% f");
_DEF_V_ALIASED(4, F32, @"% f");
_V_FNS_F_ALIASED(2, V2F32);
_V_FNS_F_ALIASED(3, V3F32);
_V_FNS_F_ALIASED(4, V4F32);
typedef GLKMatrix2 M2;
typedef GLKMatrix3 M3;
typedef GLKMatrix4 M4;

#define M4Ident GLKMatrix4Identity
#define M4TransXYZ(m, x, y, z) GLKMatrix4Translate(m, x, y, z)
#define M4TransXY(m, x, y) M4TransXYZ(m, x, y, 0)
#define M4Trans2(m, v2) M4TransXY(m, v2.x, v2.y)

#define M4ScaleXYZ(m, x, y, z) GLKMatrix4Scale(m, x, y, z)
#define M4ScaleXY(m, x, y) M4ScaleXYZ(m, x, y, 1)
#define M4Scale(m, s) M4ScaleXYZ(m, s, s, s)
#define M4Scale2(m, v2) M4ScaleXY(m, v2.x, v2.y)

#else // !QK_USE_GLK
_DEF_V(2, F32, @"% f");
_DEF_V(3, F32, @"% f");
_DEF_V(4, F32, @"% f");
_V_FNS_F_LOCAL(2, V2F32);
_V_FNS_F_LOCAL(3, V3F32);
_V_FNS_F_LOCAL(4, V4F32);
#endif // QK_USE_GLK

typedef V2F32 V2;
static const V2 V2Zero = {{}};
#define V2Make V2F32Make
#define V2Neg V2F32Neg
#define V2Inv V2F32Inv
#define V2Add V2F32Add
#define V2Sub V2F32Sub
#define V2Mul V2F32Mul
#define V2Div V2F32Div
#define V2Desc V2F32Desc
#define V2Angle V2F32Angle
#define V2Mean V2F32Mean
#define V2Dist V2F32Dist


_DEF_V(2, U8, @"%uc");
_DEF_V(2, U16, @"%hu");
_DEF_V(2, U32, @"%u");
_DEF_V(2, I32, @"%d");
_DEF_V(2, I64, @"%lld");
_DEF_V(2, F64, @"% f");

_DEF_V(3, U8, @"%uc");
_DEF_V(3, U16, @"%hu");
_DEF_V(3, I32, @"%d");
_DEF_V(3, F64, @"% f");

_DEF_V(4, U8, @"%uc");
_DEF_V(4, U16, @"%hu");
_DEF_V(4, F64, @"% f");

_V_FNS_F_LOCAL(2, V2F64);
_V_FNS_F_LOCAL(3, V3F64);
_V_FNS_F_LOCAL(4, V4F64);

_DEF_V_F_WITH_I(2, F32, U16);
_DEF_V_F_WITH_I(2, F32, I32);
_DEF_V_F_WITH_I(2, F32, U32);
_DEF_V_F_WITH_I(2, F64, U16);
_DEF_V_F_WITH_I(2, F64, I32);
_DEF_V_F_WITH_I(2, F64, U32);

_DEF_TVA_WITH_TVB(2, V2F32, V2F64);
_DEF_TVA_WITH_TVB(2, V2F64, V2F32);

typedef V2U16 Seg;
typedef V3U16 Tri;


// perpendicular vector
static inline V2F32 V2F32Perp(V2F32 v) { return V2F32Make(v.v[1], -v.v[0]); }

static inline V2F32 V2F32NormPerp(V2F32 v) { return V2F32Norm(V2F32Perp(v)); }

static inline F64 V2F32Angle(V2F32 a, V2F32 b) { return atan2(b.v[1] - a.v[1], b.v[0] - a.v[0]); }


// expand a range stored in a vector with a scalar value.
#define EXPAND_RANGE_VEC(range, val) { \
__typeof__(val) __val = (val); \
if (__val < range.v[0]) range.v[0] = __val; \
if (__val > range.v[1]) range.v[1] = __val; \
}

// expand a range stored as two vectors with a vector value.
#define EXPAND_VEC_RANGE(dim, a, b, c) { \
__typeof__(c) __c = (c); \
for_in(i, dim) { \
if (__c.v[i] < a.v[i]) a.v[i] = __c.v[i]; \
if (__c.v[i] > b.v[i]) b.v[i] = __c.v[i]; \
} \
}
