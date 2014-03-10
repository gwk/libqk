// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKImage.h"


#if LIB_JPG_AVAILABLE
@interface QKImage (JPG)

DEC_INIT(JpgPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt div:(int)div error:(NSError**)errorPtr);
DEC_INIT(JpgPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt error:(NSError**)errorPtr);
+ (QKImage*)jpgNamed:(NSString*)resourceName fmt:(QKPixFmt)fmt;

@end
#endif
