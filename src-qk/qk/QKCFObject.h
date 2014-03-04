// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"


@interface QKCFObject : NSObject {
  void* _ref; // CFTypeRef
}

@property (nonatomic, readonly) void* ref;

- (instancetype)initWithRetainedRef:(void*) CF_RELEASES_ARGUMENT ref;
+ (instancetype)withRetainedRef:(void*) CF_RELEASES_ARGUMENT ref;

DEC_INIT(Ref:(void*)ref);

- (void*)ref NS_RETURNS_INNER_POINTER;

@end

