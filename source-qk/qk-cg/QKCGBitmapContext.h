// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKCGColorSpace.h"
#import "QKCGContext.h"


@interface QKCGBitmapContext : QKCGContext

@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, readonly) V2I32 size;

@property (nonatomic, readonly) const void* bytes;
@property (nonatomic, readonly) void* mutableBytes;

+ (id)withFormat:(QKPixFmt)format size:(V2I32)size;
+ (id)withFormat:(QKPixFmt)format image:(UIImage*)image flipY:(BOOL)flipY;

- (void)fillWithImage:(UIImage*)image flipY:(BOOL)flipY;

// remove alpha bytes; we do this in place and require user to act appropriately.
// note that this is useful both for RGBX and RGBA formats.
- (QKPixFmt)exciseAlphaChannel;

@end

