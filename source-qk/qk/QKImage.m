// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSBundle+QK.h"
#import "NSError+QK.h"
#import "NSOutputStream+QK.h"
#import "NSString+QK.h"
#import "NSObject+JNB.h"
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


PROPERTY_STRUCT_FIELD(I32, width, Width, V2I32, _size, _[0]);
PROPERTY_STRUCT_FIELD(I32, height, Height, V2I32, _size, _[1]);


- (GLenum)glDataFormat {
  return QKPixFmtGlDataFormat(_format);
}


- (GLenum)glDataType {
  return QKPixFmtGlDataType(_format);
}



LAZY_CLASS_METHOD(NSDictionary*, jnbValTypes, @{
                  @"format" : [NSString class],
                  @"width" : [NSNumber class],
                  @"height" : [NSNumber class],
                  });


LAZY_CLASS_METHOD(NSDictionary*, jnbValDecoders, @{
                  
                  @"format" : ^(NSString* format){
  QKPixFmt f = QKPixFmtFromString(format);
  if (!f) {
    return (id)[NSError withDomain:JNBErrorDomain code:JNBErrorCodeKeyMissing desc:@"bad format" info:@{
                @"format" : format
                }];
  }
  return (id)@(f);
},
                  @"width" : ^(NSNumber* width) {
  if (width.intValue < 0) {
    return (id)[NSError withDomain:JNBErrorDomain code:JNBErrorCodeKeyMissing desc:@"bad width" info:@{
                @"width" : width
                }];
  }
  return (id)width;
},
                  
                  @"height" : ^(NSNumber* height) {
  if (height.intValue < 0) {
    return (id)[NSError withDomain:JNBErrorDomain code:JNBErrorCodeKeyMissing desc:@"bad height" info:@{
                @"height" : height
                }];
  }
  return (id)height;
},
                  });


LAZY_CLASS_METHOD(NSDictionary*, jnbValEncoders, @{
                  @"format" : ^(NSNumber* format) {
  return QKPixFmtDesc(format.intValue);
}
                  });


- (NSError*)jnbDataDecode:(id<QKData>)data {
  _data = data;
  if (!data) {
    return [NSError withDomain:JNBErrorDomain code:JNBErrorCodeDataMissing desc:@"nil data" info:nil];
  }
  
  return nil;
}


- (NSError*)jnbDataEncode:(NSOutputStream *)stream {
  Int written = [stream writeData:_data];
  return written < 0 ? stream.streamError : nil;
}


- (void)validate {
  qk_check(_size._[0] >= 0 && _size._[1] >= 0 && _size._[0] * _size._[1] * QKPixFmtBytesPerPixel(_format) == _data.length,
        @"bad args; %@; data.length: %ld", self, _data.length);
}


DEF_INIT(Format:(QKPixFmt)format size:(V2I32)size data:(id<QKData>)data) {
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
                             info:@{
               @"path" : path
               }];
  return nil;
}


+ (QKImage*)named:(NSString*)resourceName alpha:(BOOL)alpha {
  return [self withPath:[NSBundle resPath:resourceName] map:YES alpha:alpha error:nil];
}

@end

