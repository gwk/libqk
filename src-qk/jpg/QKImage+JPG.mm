// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <turbojpeg.h>

#import "NSBundle+QK.h"
#import "NSData+QK.h"
#import "NSMutableData+QK.h"
#import "QKErrorDomain.h"
#import "QKImage+JPG.h"


@implementation QKImage (JPG)


- (id)initWithJpgData:(id<QKData>)jpgData alpha:(BOOL)alpha name:(NSString*)name error:(NSError**)errorPtr {

  tjhandle handle = tjInitDecompress();
  qk_check(handle, @"could not init JPG decompressor");
  
  V2I32 s = {0, 0};
  int subsamples = 0;

  int code = tjDecompressHeader2(handle, (U8*)jpgData.bytes, jpgData.length, &s.v[0], &s.v[1], &subsamples);
  CHECK_SET_ERROR_RET_NIL(code == 0, QK, ImageJPGReadHeader, @"JPG read header failed",
                          @{@"name" : name});

  int jpgPixFmt;
  QKPixFmt fmt;
  int channels;
  if (alpha) {
    jpgPixFmt = TJPF_RGBA;
    fmt = QKPixFmtRGBAU8;
    channels = 4;
  }
  else {
    jpgPixFmt = TJPF_RGB;
    fmt = QKPixFmtRGBU8;
    channels = 3;
  }
  int flags = TJFLAG_BOTTOMUP | TJFLAG_ACCURATEDCT;
  NSMutableData* data = [NSMutableData withLength:V2I32Measure(s) * channels];
  code = tjDecompress2(handle,
                       (U8*)jpgData.bytes, // API is not const-correct
                       jpgData.length,
                       (U8*)data.mutableBytes,
                       s.v[0],
                       0, // pitch; set to 0 for tightly packed data
                       s.v[1],
                       jpgPixFmt,
                       flags);

  CHECK_SET_ERROR_RET_NIL(code == 0, QK, ImageJPGDecompress, @"JPG decompression failed",
                          @{@"name" : name});
    
  tjDestroy(handle);

  return [self initWithFormat:fmt size:s data:data];
}


DEF_INIT(JpgPath:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr) {
  NSData* jpgData = [NSData withPath:path map:map error:errorPtr];
  if (errorPtr && *errorPtr) {
    return nil;
  }
  return [self initWithJpgData:jpgData alpha:alpha name:path error:errorPtr];
}


+ (QKImage*)jpgNamed:(NSString*)resourceName alpha:(BOOL)alpha {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  qk_check(path, @"no JPG image named: %@", resourceName);
  NSError* e = nil;
  QKImage* i = [self withJpgPath:path map:YES alpha:alpha error:&e];
  qk_check(!e, @"JPG resource failed to load: %@", e);
  return i;
}


@end

