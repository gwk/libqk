// Copyright 2007-2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-vec.h"
#import "GLObject.h"


@interface GLTexture : GLObject

@property (nonatomic, readonly) GLenum target; // e.g. GL_TEXTURE_2D
@property (nonatomic, readonly) GLenum format; // e.g. ?
@property (nonatomic, readonly) V2I32 size;

- (id)initWithTarget:(GLenum)target // e.g. GL_TEXTURE_2D
              format:(GLenum)format // e.g. GL_RGBA8
                size:(V2I32)size
          dataFormat:(GLenum)dataFormat // e.g. GL_RGBA
            dataType:(GLenum)dataType   // e.g. GL_FLOAT
               bytes:(void*)bytes;

+ (id)withTarget:(GLenum)target
          format:(GLenum)format
            size:(V2I32)size
      dataFormat:(GLenum)dataFormat
        dataType:(GLenum)dataType
           bytes:(void*)bytes;

- (void)setFilter:(GLenum)filter;
- (void)setWrap:(GLenum)wrap;

- (void)bindToTarget;
- (void)unbindFromTarget;

- (GLenum) target;
- (GLint) width;
- (GLint) height;

@end
