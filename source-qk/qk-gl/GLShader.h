// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLObject.h"


@interface GLShader : GLObject

- (id)initWithSource:(NSString*)source;
+ (id)withSource:(NSString*)source;
+ (id)named:(NSString*)resourceName;

@end
