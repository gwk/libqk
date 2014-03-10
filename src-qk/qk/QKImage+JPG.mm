// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "NSBundle+QK.h"
#import "NSData+QK.h"
#import "NSMutableData+QK.h"
#import "QKErrorDomain.h"
#import "QKImage+JPG.h"


#if LIB_JPG_AVAILABLE
@implementation QKImage (JPG)


- (id)initWithJpgData:(id<QKData>)jpgData fmt:(QKPixFmt)fmt div:(int)div name:(NSString*)name error:(NSError**)errorPtr {

#if 0 // use to debug scaling factors.
  int numScalingFactors = -1;
  tjscalingfactor* scalingFactors = tjGetScalingFactors(&numScalingFactors);
  qk_assert(scalingFactors, @"no scaling factors supported");
  for_in(i, numScalingFactors) {
    auto f = scalingFactors[i];
    errFL(@"scaling factor: %d / %d", f.num, f.denom);
  }
#endif
  
  tjhandle handle = tjInitDecompress();
  qk_check(handle, @"could not init JPG decompressor");
  
  V2I32 size = {0, 0};
  int subsamples = 0;
  
  int code = tjDecompressHeader2(handle, (U8*)jpgData.bytes, jpgData.length, &size.v[0], &size.v[1], &subsamples);
  CHECK_SET_ERROR_RET_NIL(code == 0, QK, ImageJPGReadHeader, @"JPG read header failed",
                          @{@"name" : name});
  
  size.v[0] /= div;
  size.v[1] /= div;
  
  int flags = TJFLAG_BOTTOMUP | TJFLAG_ACCURATEDCT;

  NSMutableData* data = [NSMutableData withLength:V2I32Measure(size) * QKPixFmtBytesPerPixel(fmt)];
  code = tjDecompress2(handle,
                       (U8*)jpgData.bytes, // API is not const-correct
                       jpgData.length,
                       (U8*)data.mutableBytes,
                       size.v[0],
                       0, // pitch; set to 0 for tightly packed data
                       size.v[1],
                       QKPixFmtTJPF(fmt),
                       flags);

  CHECK_SET_ERROR_RET_NIL(code == 0, QK, ImageJPGDecompress, @"JPG decompression failed",
                          @{@"name" : name});
    
  tjDestroy(handle);

  return [self initWithFormat:fmt size:size data:data];
}


DEF_INIT(JpgPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt div:(int)div error:(NSError**)errorPtr) {
  NSData* jpgData = [NSData withPath:path map:map error:errorPtr];
  if (errorPtr && *errorPtr) {
    return nil;
  }
  return [self initWithJpgData:jpgData fmt:fmt div:div name:path error:errorPtr];
}


DEF_INIT(JpgPath:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt error:(NSError**)errorPtr) {
  return [self initWithJpgPath:path map:map fmt:fmt div:1 error:errorPtr];
}


+ (QKImage*)jpgNamed:(NSString*)resourceName fmt:(QKPixFmt)fmt {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  qk_check(path, @"no JPG image named: %@", resourceName);
  NSError* e = nil;
  QKImage* i = [self withJpgPath:path map:YES fmt:fmt div:1 error:&e];
  qk_check(!e, @"JPG resource failed to load: fmt: %@; path: %@\n  e: %@", QKPixFmtDesc(fmt), path, e);
  return i;
}


@end
#endif
