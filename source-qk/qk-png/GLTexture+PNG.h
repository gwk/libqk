// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "PNGImage.h"


@interface GLTexture (PNG)

+ (id)withFormat:(GLenum)format PNGImage:(PNGImage*)image;

@end

