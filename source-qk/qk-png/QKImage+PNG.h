// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


extern NSString* const QKImagePNGErrorDomain;

typedef enum {
  QKImagePNGErrorCodeOpenFile,
  QKImagePNGErrorCodeSignature,
  QKImagePNGErrorCodeRead,
  QKImagePNGErrorCodeRowsLength,
} QKImagePNGErrorCode;


@interface QKImage (PNG)

+ (id)withPngPath:(NSString*)path alpha:(BOOL)alpha error:(NSError**)errorPtr;
+ (QKImage*)pngNamed:(NSString*)resourceName alpha:(BOOL)alpha;

@end

