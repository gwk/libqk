// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface NSBundle (QK)

+ (NSString*)resPath:(NSString*)resourceName ofType:(NSString*)type;
+ (NSString*)resPath:(NSString*)resourceName;

+ (id)jsonNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options;

+ (NSDictionary*)dictNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options;
+ (NSArray*)arrayNamed:(NSString*)resourceName options:(NSJSONReadingOptions)options;

@end

