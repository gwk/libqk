// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-cg-util.h"


const CGRect CGRectUnit = { 0, 0, 1, 1};


CGRect CGRectWithAspectEnclosingRect(CGFloat aspect, CGRect r) {
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

