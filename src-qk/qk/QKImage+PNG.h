// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface QKImage (PNG)

#if LIB_PNG_AVAILABLE
DEC_INIT(PngPath:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr);
+ (QKImage*)pngNamed:(NSString*)resourceName alpha:(BOOL)alpha;
#endif

@end

