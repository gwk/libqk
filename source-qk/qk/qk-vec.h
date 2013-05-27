// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"
#import "qk-macros.h"
#import "qk-math.h"

// alias the GLK vector and matrix types to be shorter; add additional, similarly structured types for other scalar types.
// the naming convention is VDT, where D is the dimension (e.g. '2'), and T is the scalar element type, (e.g. 'F32').
// we make use of C compound literals, which look like type-casts of array literals (e.g, '(V2F32) { { 0, 0 } }').
// this has the advantage that unspecified fields are zero-initialized,
// which allows for generic conversions between dimensions.

#define _DEF_V(TE, TV, dim) \
\
static const TV TV##Zero = (TV) {{}}; \
\
static inline F64 TV##Aspect(TV v, TE eps) { \
return (v.v[0] < eps || v.v[1] < eps) ? 0 : (F64)v.v[0] / (F64)v.v[1]; \
} \
\
static inline TE TV##Measure(TV v) { TE m = 1; for_in(i, dim) m *= v.v[i]; return m; } \
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
TV r; for_in(i, dim) r.v[i] = lerp(a.v[i], b.v[i], t); return r; \
}\
\
static inline BOOL TV##LT(TV a, TV b) { \
for_in(i, dim) { if (a.v[i] < b.v[i]) return YES; if (a.v[i] > b.v[i]) return NO; } return NO; \
} \
\
static inline BOOL TV##LTRev(TV a, TV b) { \
for_in_rev(i, dim) { if (a.v[i] < b.v[i]) return YES; if (a.v[i] > b.v[i]) return NO; } return NO; \
} \
\
static inline TV TV##WithCGPoint(CGPoint p) { return (TV) {{ p.x, p.y }}; } \
\
static inline TV TV##WithCGSize(CGSize s) { return (TV) {{ s.width, s.height }}; } \
\
static inline CGPoint CGPointWith##TV(TV v) { return CGPointMake(v.v[0], v.v[1]); } \
\
static inline CGSize CGSizeWith##TV(TV v) { return CGSizeMake(v.v[0], v.v[1]); } \


#define _DEF_V2(TE, TV, fmt) \
_DEF_V(TE, TV, 2) \
\
static const TV TV##Unit = (TV) {{ 1, 1 }}; \
\
static inline TV TV##Make(TE x, TE y) { return (TV) {{ x, y }}; } \
\
static inline NSString* TV##Desc(TV v) { \
return [NSString stringWithFormat:@"(" fmt @" " fmt @")", v.v[0], v.v[1]]; \
} \
\
static inline TV TV##UpdateRange(TV r, TE v) { \
return (TV) { (v < r.v[0] ? v : r.v[0]), (v > r.v[1] ? v : r.v[1]) }; \
}


#define _DEF_V3(TE, TV, fmt) \
_DEF_V(TE, TV, 3) \
\
static const TV TV##Unit = (TV) {{ 1, 1, 1 }}; \
\
static inline TV TV##Make(TE x, TE y, TE z) { return (TV) {{ x, y, z }}; } \
\
static inline NSString* TV##Desc(TV v) { \
return [NSString stringWithFormat:@"(" fmt @" " fmt @" " fmt @")", v.v[0], v.v[1], v.v[2]]; \
} \


#define _DEF_V4(TE, TV, fmt) \
_DEF_V(TE, TV, 4) \
\
static const TV TV##Unit = (TV) {{ 1, 1, 1, 1 }}; \
\
static inline TV TV##Make(TE x, TE y, TE z, TE w) { return (TV) {{ x, y, z, w }}; } \
\
static inline NSString* TV##Desc(TV v) { \
return [NSString stringWithFormat:@"(" fmt @" " fmt @" " fmt @" " fmt @")", v.v[0], v.v[1], v.v[2], v.v[3]]; \
} \


#define _TYPEDEF_V(dim, TE, fmt) \
typedef struct { TE v[dim]; } V##dim##TE; \
_DEF_V##dim(TE, V##dim##TE, fmt)



#define _DEF_V_F(dim, TV) \
\
static inline TV TV##InvVec(TV v) { TV r; for_in(i, dim) r.v[i] = 1.0 / v.v[i]; return r; } \
\
static inline TV TV##Mean(TV a, TV b) { return TV##Div(TV##Add(a, b), 2); } \
\
static inline F64 TV##Dot(TV a, TV b) { F64 d = 0; for_in(i, dim) d += a.v[i] * b.v[i]; return d; } \
\
static inline F64 TV##Mag(TV v) { return sqrt(TV##Dot(v, v)); } \
\
static inline F64 TV##Dist(TV a, TV b) { return TV##Mag(TV##Sub(a, b)); } \
\
static inline TV TV##Norm(TV v) { return TV##Div(v, TV##Mag(v)); } \


#define _DEF_V_F_WITH_I_EXP(dim, TF, TI, TVF, TVI) \
static inline TVF TVF##With##TI(TVI v) { \
TVF r; for_in(i ,dim) r.v[i] = v.v[i]; \
return r; \
} \
\
static inline TVF TVF##With##TI##Scaled(TVI v, F64 scale) { \
  TVF r; for_in(i ,dim) r.v[i] = v.v[i] / scale; \
  return r; \
}

#define _DEF_V_F_WITH_I(dim, TF, TI) \
_DEF_V_F_WITH_I_EXP(dim, TF, TI, V##dim##TF, V##dim##TI)


#define _DEF_TVA_WITH_TVB(dim, TVA, TVB) \
static inline TVA TVA##With##TVB(TVB v) { \
TVA r; for_in(i ,dim) r.v[i] = v.v[i]; \
return r; \
}

#if 0
typedef GLKVector2 V2F32;
typedef GLKVector3 V3F32;
typedef GLKVector4 V4F32;
_DEF_V2(F32, V2F32, @"% f");
_DEF_V3(F32, V3F32, @"% f");
_DEF_V4(F32, V4F32, @"% f");
#else
_TYPEDEF_V(2, F32, @"% f");
_TYPEDEF_V(3, F32, @"% f");
_TYPEDEF_V(4, F32, @"% f");
#endif

#define V2Make V2F32Make
#define V3Make V3F32Make
#define V4Make V4F32Make

typedef V2F32 V2;
typedef V3F32 V3;
typedef V4F32 V4;
static const V2 V2Zero = {{}};
static const V3 V3Zero = {{}};
static const V4 V4Zero = {{}};



_TYPEDEF_V(2, U8, @"%uc");
_TYPEDEF_V(2, U16, @"%hu");
_TYPEDEF_V(2, U32, @"%u");
_TYPEDEF_V(2, I32, @"%d");
_TYPEDEF_V(2, I64, @"%lld");
_TYPEDEF_V(2, F64, @"% f");

_TYPEDEF_V(3, U8, @"%uc");
_TYPEDEF_V(3, U16, @"%hu");
_TYPEDEF_V(3, I32, @"%d");
_TYPEDEF_V(3, F64, @"% f");

_TYPEDEF_V(4, U8, @"%uc");
_TYPEDEF_V(4, U16, @"%hu");
_TYPEDEF_V(4, F64, @"% f");

_DEF_V_F(2, V2F32);
_DEF_V_F(2, V2F64);
_DEF_V_F(3, V3F32);
_DEF_V_F(3, V3F64);
_DEF_V_F(4, V4F32);
_DEF_V_F(4, V4F64);

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

