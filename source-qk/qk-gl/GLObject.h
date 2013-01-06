// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface GLObject : NSObject {
  GLuint _handle;
}

@property (nonatomic) GLuint handle;

@end
