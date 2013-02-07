// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKImage (JPG)

+ (id)withJpgPath:(NSString*)path alpha:(BOOL)alpha;
+ (QKImage*)jpgNamed:(NSString*)resourceName alpha:(BOOL)alpha;

@end

