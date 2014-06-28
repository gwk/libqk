// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "QKImage.h"


#if LIB_PNG_AVAILABLE
@interface QKImage (PNG)

DEC_INIT(PngPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt error:(NSError**)errorPtr);
+ (QKImage*)pngNamed:(NSString*)resourceName fmt:(QKPixFmt)fmt;

@end
#endif
