// Copyright 2007-2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "GLObject.h"


@interface GLShader : GLObject

@property (nonatomic, readonly) NSString* name;

DEC_INIT(Sources:(NSArray*)source name:(NSString*)name);

+ (id)withResourceNames:(NSArray*)resourceNames;

- (NSString*)infoLog;

@end
