// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKCFObject : NSObject {
  void* _ref; // CFTypeRef
}

@property (nonatomic, readonly) void* ref;

- (id)initWithRetainedRef:(void*) CF_RELEASES_ARGUMENT ref;
- (id)initWithRef:(void*)ref;
+ (id)withRetainedRef:(void*) CF_RELEASES_ARGUMENT ref;
+ (id)withRef:(void*)ref;

- (void*)ref NS_RETURNS_INNER_POINTER;

@end

