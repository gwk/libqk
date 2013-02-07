// Copyright 2007-2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-vec.h"
#import "GLObject.h"


@interface GLTexture : GLObject

@property (nonatomic, readonly) GLenum target; // e.g. GL_TEXTURE_2D
@property (nonatomic, readonly) GLenum format; // e.g. ?
@property (nonatomic, readonly) V2I32 size;


+ (id)withFormat:(GLenum)format     // e.g. GL_RGBA
            size:(V2I32)size
      dataFormat:(GLenum)dataFormat // e.g. GL_RGBA
        dataType:(GLenum)dataType   // e.g. GL_FLOAT
           bytes:(const void*)bytes;

+ (id)withFormat:(GLenum)format image:(QKImage*)image;

- (void)setFilter:(GLenum)filter;
- (void)setWrap:(GLenum)wrap;

- (void)bindToTarget;
- (void)unbindFromTarget;

+ (BOOL)bind:(GLTexture*)texture target:(GLenum)target; // handles nil texture by binding 0 and returning NO.

- (GLenum) target;
- (GLint) width;
- (GLint) height;

@end
