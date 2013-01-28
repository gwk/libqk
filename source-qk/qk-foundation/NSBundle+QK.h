// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface NSBundle (QK)

+ (NSString*)resPath:(NSString*)resourceName ofType:(NSString*)type;
+ (NSString*)resPath:(NSString*)resourceName;

@end

