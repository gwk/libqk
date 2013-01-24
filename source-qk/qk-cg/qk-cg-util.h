// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


extern const CGRect CGRectUnit;


static inline CGRect CGRectWithS(CGSize size) {
  return (CGRect){CGPointZero, size};
}

static inline CGRect CGRectWithOE(CGPoint origin, CGPoint end) {
  return (CGRect){origin.x, origin.y, end.x - origin.x, end.y - origin.y};
}


static inline CGRect CGRectExpand(CGRect r, CGFloat width, CGFloat height) {
  return (CGRect){r.origin.x - width, r.origin.y - height, r.size.width + width * 2, r.size.height + height * 2};
}
