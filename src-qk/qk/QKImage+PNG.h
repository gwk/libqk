// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#if LIB_PNG_AVAILABLE
@interface QKImage (PNG)

DEC_INIT(PngPath:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr);
+ (QKImage*)pngNamed:(NSString*)resourceName alpha:(BOOL)alpha;

@end
#endif
