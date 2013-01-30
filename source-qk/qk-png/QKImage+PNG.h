// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKImage (PNG)

+ (id)withPngPath:(NSString*)path alpha:(BOOL)alpha;
+ (QKImage*)pngNamed:(NSString*)resourceName alpha:(BOOL)alpha;

@end

