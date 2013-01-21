// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLTexture+PNG.h"


@implementation GLTexture (PNG)

+ (id)withFormat:(GLenum)format PNGImage:(PNGImage*)image {
  
  GLenum dataFormat = (image.hasAlpha ? GL_RGBA : GL_RGB);
  check(image.bitDepth == 8, @"unsupported PNG bit depth: %d", image.bitDepth);
  GLenum dataType = GL_UNSIGNED_BYTE;
  
  return [self withFormat:format
                     size:image.size
               dataFormat:dataFormat
                 dataType:dataType
                    bytes:image.data.bytes];
}


@end

