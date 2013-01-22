// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKCFObject.h"


@interface QKCFObject ()
@end


@implementation QKCFObject

- (void)dealloc {
  CFRelease(_ref);
}


- (id)initWithRetainedRef:(void*)ref {
  INIT(super init);
  check(ref, @"NULL ref");
  _ref = ref;
  return self;
}


- (id)initWithRef:(void*)ref {
  return [self initWithRetainedRef:(void*)CFRetain(ref)];
}


+ (id)withRetainedRef:(void*)ref {
  return [[self alloc] initWithRetainedRef:ref];
}


+ (id)withRef:(void*)ref {
  return [[self alloc] initWithRef:ref];
}


@end

