// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKPixFmt.h"
#import "QKSubData.h"


@interface QKImage : NSObject

@property (nonatomic, readonly) V2I32 size;
@property (nonatomic, readonly) QKSubData* data;
@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, readonly) GLenum glDataFormat;
@property (nonatomic, readonly) GLenum glDataType;
@property (nonatomic, readonly) const void* bytes;

@end

