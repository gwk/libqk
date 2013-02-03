// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


extern const CGRect CGRectUnit;


static inline CGPoint CGPointMul(CGPoint v, CGFloat s) {
  return (CGPoint){ v.x * s, v.y * s };
}


static inline CGSize CGSizeMul(CGSize v, CGFloat s) {
  return (CGSize){ v.width * s, v.height * s };
}


static inline CGRect CGRectMul(CGRect r, CGFloat s) {
  return (CGRect){ CGPointMul(r.origin, s), CGSizeMul(r.size, s) };
}


static inline CGRect CGRectWithS(CGSize size) {
  return (CGRect){CGPointZero, size};
}

static inline CGRect CGRectWithOE(CGPoint origin, CGPoint end) {
  return (CGRect){origin.x, origin.y, end.x - origin.x, end.y - origin.y};
}


static inline CGRect CGRectExpand(CGRect r, CGFloat width, CGFloat height) {
  return (CGRect){r.origin.x - width, r.origin.y - height, r.size.width + width * 2, r.size.height + height * 2};
}


static inline CGFloat CGSizeAspect(CGSize s) {
  return s.width / s.height;
}

