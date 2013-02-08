// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKImage.h"


extern NSString* const QKImageJPGErrorDomain;

typedef enum {
  QKImageJPGErrorCodeReadHeader,
  QKImageJPGErrorCodeDecompress,
} QKImageJPGErrorCode;


@interface QKImage (JPG)

+ (id)withJpgPath:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr;
+ (QKImage*)jpgNamed:(NSString*)resourceName alpha:(BOOL)alpha;

@end

