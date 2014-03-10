// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKImage.h"


@interface QKImage (JPG)

#if LIB_JPG_AVAILABLE
DEC_INIT(JpgPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt div:(int)div error:(NSError**)errorPtr);
DEC_INIT(JpgPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt error:(NSError**)errorPtr);
+ (QKImage*)jpgNamed:(NSString*)resourceName fmt:(QKPixFmt)fmt;
#endif

@end

