// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "NSBundle+QK.h"
#import "NSData+QK.h"
#import "NSError+QK.h"
#import "NSOutputStream+QK.h"
#import "NSString+QK.h"
#import "QKErrorDomain.h"
#import "QKImage.h"

#ifdef PNG_H
# define LIB_PNG_AVAILABLE 1
# import "QKImage+PNG.h"
#else
# define LIB_PNG_AVAILABLE 0
#endif

#ifdef __TURBOJPEG_H__
# define LIB_JPG_AVAILABLE 1
# import "QKImage+JPG.h"
#else
# define LIB_JPG_AVAILABLE 0
#endif


@interface QKImage ()
@end


@implementation QKImage


#pragma mark - NSObject


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %@ %@>", self.class, self, QKPixFmtDesc(_format), V2I32Desc(_size)];
}


#pragma mark - QKData


- (const void*)bytes {
  return _data.bytes;
}


- (Int)length {
  return _data.length;
}


- (BOOL)isMutable {
  return _data.isMutable;
}


#pragma mark - QKImage


- (NSString*)formatDesc {
  return QKPixFmtDesc(_format);
}


PROPERTY_STRUCT_FIELD(I32, width, Width, V2I32, _size, v[0]);
PROPERTY_STRUCT_FIELD(I32, height, Height, V2I32, _size, v[1]);


- (GLenum)glDataFormat {
  return QKPixFmtGlDataFormat(_format);
}


- (GLenum)glDataType {
  return QKPixFmtGlDataType(_format);
}


- (void)validate {
  qk_check(_size.v[0] >= 0 && _size.v[1] >= 0 && _size.v[0] * _size.v[1] * QKPixFmtBytesPerPixel(_format) == _data.length,
           @"bad args; %@; data.length: %ld", self, _data.length);
}


DEF_INIT(Format:(QKPixFmt)format size:(V2I32)size data:(NSData*)data) {
  INIT(super init);
  _format = format;
  _size = size;
  _data = data;
  [self validate];
  return self;
}


DEF_INIT(Path:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr) {
  CHECK_SET_ERROR_RET_NIL(path, QK, NilPath, @"nil path", nil);
  
  NSString* ext = path.pathExtension; UNUSED_VAR(ext);
  
#if LIB_PNG_AVAILABLE
  if ([ext isEqualToString:@"png"]) {
    return [self initWithPngPath:path map:map alpha:alpha error:errorPtr];
  }
#endif
#if LIB_JPG_AVAILABLE
  if ([ext isEqualToString:@"jpg"]) {
    return [self initWithJpgPath:path map:map alpha:alpha error:errorPtr];
  }
#endif
  qk_check(errorPtr, @"QKImage: unrecognized path extension: %@", path);
  *errorPtr = [NSError withDomain:QKErrorDomain
                             code:QKErrorCodeImageUnrecognizedPathExtension
                             desc:@"unrecognized path extension"
                             info:@{@"path" : path}];
  return nil;
}


+ (QKImage*)named:(NSString*)resourceName alpha:(BOOL)alpha {
  return [self withPath:[NSBundle resPath:resourceName] map:YES alpha:alpha error:nil];
}


- (UIImage*)uiImage {
  auto provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)_data);
  auto colorSpace = QKPixFmtCreateCGColorSpace(_format);
  
  auto image =
  CGImageCreate(_size.v[0],
                _size.v[1],
                8, // bits per component
                QKPixFmtBitsPerPixel(_format),
                QKPixFmtBytesPerPixel(_format) * _size.v[0],
                colorSpace,
                QKPixFmtBitmapInfo(_format),
                provider,
                NULL, // decode
                false, // shouldInterpolate
                kCGRenderingIntentDefault); // intent
  
  if (!image) {
    errFL(@"could not create CGImageRef from QKImage: %@", self);
  }
  auto i = [UIImage imageWithCGImage:image];
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  CGImageRelease(image);
  return i;
}



@end

