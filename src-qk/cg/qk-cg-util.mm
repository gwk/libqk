// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-cg-util.h"

const CGSize CGSizeUnit = { 1, 1};
const CGRect CGRectUnit = { 0, 0, 1, 1};
const CGRect CGRect256 = { 0, 0, 256, 256 };


CGColorSpaceRef QKColorSpaceRGB() {
  static CGColorSpaceRef s = CGColorSpaceCreateDeviceRGB();
  return s;
}


CGColorSpaceRef QKColorSpaceLum() {
  static CGColorSpaceRef s = CGColorSpaceCreateDeviceGray();
  return s;
}


CGColorSpaceRef QKColorSpaceDev(BOOL rgb) {
  return rgb ? QKColorSpaceRGB() : QKColorSpaceLum();
}


CGColorSpaceRef QKColorSpaceWithFormat(QKPixFmt format) {
  if (format & QKPixFmtBitRGB) {
    return QKColorSpaceRGB();
  }
  if (format & QKPixFmtBitL) {
    return QKColorSpaceLum();
  }
  return NULL; // mask format; no color space.
}


CGSize CGSizeWithAspectEnclosingSize(CGFloat aspect, CGSize s) {
  if (!aspect) {
    return s;
  }
  CGFloat r_aspect = CGSizeAspect(s, 0);
  if (r_aspect < aspect) { // e is wide/short relative to r; expand r width.
    return CGSizeMake(s.height * aspect, s.height);
  }
  else { // e is thin/tall relative to r; expand r height.
    return CGSizeMake(s.width, s.width / aspect);
  }
}


CGSize CGSizeWithAspectEnclosedBySize(CGFloat aspect, CGSize s) {
  if (!aspect) {
    return s;
  }
  CGFloat r_aspect = CGSizeAspect(s, 0);
  if (r_aspect < aspect) { // e is wide/short relative to r; shrink r height
    return CGSizeMake(s.width, s.width / aspect);
  }
  else { // e is thin/tall relative to r; shrink r width
    return CGSizeMake(s.height * aspect, s.height);
  }
}


CGRect CGRectWithAspectEnclosingRect(CGFloat aspect, CGRect r) {
  if (!aspect) {
    return r;
  }
  CGFloat r_aspect = CGSizeAspect(r.size, 0);
  CGRect e; // rect enclosing r
  if (r_aspect < aspect) { // e is wide/short relative to r; expand r width
    e.size = CGSizeMake(r.size.height * aspect, r.size.height);
    e.origin = CGPointMake(r.origin.x + (r.size.width - e.size.width) * .5, r.origin.y);
  }
  else { // e is thin/tall relative to r; expand r height
    e.size = CGSizeMake(r.size.width, r.size.width / aspect);
    e.origin = CGPointMake(r.origin.x, r.origin.y + (r.size.height - e.size.height) * .5);
  }
  return e;
}


CGRect CGRectWithAspectEnclosedByRect(CGFloat aspect, CGRect r) {
  if (!aspect) {
    return r;
  }
  CGFloat r_aspect = CGSizeAspect(r.size, 0);
  CGRect e; // rect enclosed by r
  if (r_aspect < aspect) { // e is wide/short relative to r; shrink r height
    e.size = CGSizeMake(r.size.width, r.size.width / aspect);
    e.origin = CGPointMake(r.origin.x, r.origin.y + (r.size.height - e.size.height) * .5);
  }
  else { // e is thin/tall relative to r; shrink r width
    e.size = CGSizeMake(r.size.height * aspect, r.size.height);
    e.origin = CGPointMake(r.origin.x + (r.size.width - e.size.width) * .5, r.origin.y);
  }
  return e;
}

