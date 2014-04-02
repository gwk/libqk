// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).

#import <algorithm>
#import "qk-log.h"
#import "NSBundle+QK.h"
#import "NSData+QK.h"
#import "NSError+QK.h"
#import "NSOutputStream+QK.h"
#import "NSString+QK.h"
#import "QKErrorDomain.h"
#import "QKImage.h"
#import "QKImage+PNG.h"
#import "QKImage+JPG.h"


@interface QKImage ()
@end


@implementation QKImage


#pragma mark - NSObject


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %@ %@>", self.class, self, QKPixFmtDesc(_format), V2I32Desc(_size)];
}


#pragma mark - QKData


- (const void*)bytes {
  return self.data.bytes;
}


- (void*)mutableBytes {
  return self.data.mutableBytes;
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
           @"bad args; %@; data.length: %ld", self, self.length);
}


DEF_INIT(Format:(QKPixFmt)format size:(V2I32)size data:(NSMutableData*)data) {
  INIT(super init);
  _format = format;
  _size = size;
  _data = data;
  [self validate];
  return self;
}


DEF_INIT(Path:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt error:(NSError**)errorPtr) {
  CHECK_SET_ERROR_RET_NIL(path, QK, NilPath, @"nil path", nil);
  
  NSString* ext = path.pathExtension; UNUSED_VAR(ext);
  
#if LIB_PNG_AVAILABLE
  if ([ext isEqualToString:@"png"]) {
    return [self initWithPngPath:path map:map fmt:fmt error:errorPtr];
  }
#endif
#if LIB_JPG_AVAILABLE
  if ([ext isEqualToString:@"jpg"]) {
    return [self initWithJpgPath:path map:map fmt:fmt error:errorPtr];
  }
#endif
  qk_check(errorPtr, @"QKImage: unrecognized path extension: %@", path);
  *errorPtr = [NSError withDomain:QKErrorDomain
                             code:QKErrorCodeImageUnrecognizedPathExtension
                             desc:@"unrecognized path extension"
                             info:@{@"path" : path}];
  return nil;
}


+ (QKImage*)named:(NSString*)resourceName fmt:(QKPixFmt)fmt {
  return [self withPath:[NSBundle resPath:resourceName] map:YES fmt:fmt error:nil];
}


- (void)transpose {
  Int pl = QKPixFmtBytesPerPixel(_format); // pixel length
  Int w = _size.v[0];
  Int h = _size.v[1];
  Byte* p = (Byte*)self.mutableBytes;
  if (w == h) { // square is easy to do in place
    for_in(j, h) {
      for_imn(i, j, w) {
        Int o = pl * (w * j + i);
        Int t = pl * (w * i + j);
        for_in(k, pl) {
          std::swap(p[o + k], p[t + k]);
        }
      }
    }
  }
  else { // fancy algorithms exist, but for now use a temp copy.
    NSMutableData* d = [NSMutableData dataWithCapacity:_data.length];
    Byte* col = (Byte*)malloc(h * pl); // col buffer.
    for_in(i, w) {
      for_in(j, h) {
        Int o = pl * (w * j + i);
        for_in(k, pl) {
          col[pl * j + k] = p[o + k];
        }
      }
      [d appendBytes:col length:h * pl];
    }
    qk_assert(d.length == _data.length, @"wrong length");
    free(col);
    _data = d;
  }
  std::swap(_size.v[0], _size.v[1]);
}


- (void)flipH {
  Int pl = QKPixFmtBytesPerPixel(_format); // pixel length
  Int w = _size.v[0];
  Int h = _size.v[1];
  Byte* p = (Byte*)self.mutableBytes;
  for_in(j, h) {
    for_in(i, w / 2) {
      Int o = pl * (w * j + i);
      Int t = pl * (w * j + (w - (i + 1)));
      for_in(k, pl) {
        std::swap(p[o + k], p[t + k]);
      }
    }
  }
}


- (void)rotateQCW {
  // rotate a quarter turn (90 degrees) clockwise.
  [self transpose];
  [self flipH];
}


#if TARGET_OS_IPHONE
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
#endif


@end

