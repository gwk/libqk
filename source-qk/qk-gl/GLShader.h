// Copyright 2007-2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLObject.h"


@interface GLShader : GLObject

@property (nonatomic, readonly) NSString* name;

- (id)initWithSource:(NSString*)source name:(NSString*)name;
+ (id)withSource:(NSString*)source name:(NSString*)name;
+ (id)named:(NSString*)resourceName;

- (NSString*)infoLog;

@end
