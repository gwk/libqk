// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface GLObject : NSObject {
  GLuint _handle; // exposed for convenience of subclass implementations
}

@property (nonatomic) GLuint handle;

@end
