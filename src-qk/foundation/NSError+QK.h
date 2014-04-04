// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface NSError (QK)

+ (NSError*)withDomain:(NSString*)domain code:(int)code desc:(NSString*)desc info:(NSDictionary*)info;
+ (NSError*)withDesc:(NSString*)desc;

@end

