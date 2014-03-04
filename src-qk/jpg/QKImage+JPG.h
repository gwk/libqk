// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKImage.h"


@interface QKImage (JPG)

DEC_INIT(JpgPath:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr);

+ (QKImage*)jpgNamed:(NSString*)resourceName alpha:(BOOL)alpha;

@end

