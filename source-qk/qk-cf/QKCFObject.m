// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKCFObject.h"


@interface QKCFObject ()
@end


@implementation QKCFObject

- (void)dealloc {
  CFRelease(_ref);
}


- (id)initWithRetainedRef:(void*) CF_RELEASES_ARGUMENT ref {
  INIT(super init);
  check(ref, @"NULL ref");
  _ref = ref;
  return self;
}


+ (id)withRetainedRef:(void*) CF_RELEASES_ARGUMENT ref {
  return [[self alloc] initWithRetainedRef:ref];
}


DEF_INIT(Ref:(void*)ref) {
  return [self initWithRetainedRef:(void*)CFRetain(ref)];
}


@end

