// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


extern const CGSize CGSizeUnit;
extern const CGRect CGRectUnit;


static inline CGPoint CGPointMul(CGPoint v, CGFloat s) {
  return (CGPoint){ v.x * s, v.y * s };
}


static inline CGSize CGSizeMul(CGSize v, CGFloat s) {
  return (CGSize){ v.width * s, v.height * s };
}


static inline CGFloat CGSizeAspect(CGSize s, CGFloat eps) {
  return s.width / s.height;
}


static inline CGRect CGRectMul(CGRect r, CGFloat s) {
  return (CGRect){ CGPointMul(r.origin, s), CGSizeMul(r.size, s) };
}


static inline CGRect CGRectWithOE(CGPoint origin, CGPoint end) {
  return (CGRect){ origin.x, origin.y, end.x - origin.x, end.y - origin.y };
}


static inline CGRect CGRectWithS(CGSize size) {
  return (CGRect){ CGPointZero, size };
}


static inline CGRect CGRectWithWH(CGFloat w, CGFloat h) {
  return CGRectMake(0, 0, w, h);
}


// left, bottom, size
static inline CGRect CGRectWithLBS(CGFloat l, CGFloat b, CGSize s) {
  return CGRectMake(l, b - s.height, s.width, s.height);
}


// center-x, bottom, size
static inline CGRect CGRectWithCBS(CGFloat cx, CGFloat b, CGSize s) {
  return CGRectMake(cx - s.width * .5, b - s.height, s.width, s.height);
}


// right, bottom, size
static inline CGRect CGRectWithRBS(CGFloat r, CGFloat b, CGSize s) {
  return CGRectMake(r - s.width, b - s.height, s.width, s.height);
}


static inline CGRect CGRectExpand(CGRect r, CGFloat width, CGFloat height) {
  return (CGRect){r.origin.x - width, r.origin.y - height, r.size.width + width * 2, r.size.height + height * 2};
}


CGSize CGSizeWithAspectEnclosingSize(CGFloat aspect, CGSize s);
CGSize CGSizeWithAspectEnclosedBySize(CGFloat aspect, CGSize s);
CGRect CGRectWithAspectEnclosingRect(CGFloat aspect, CGRect r);
CGRect CGRectWithAspectEnclosedByRect(CGFloat aspect, CGRect r);
