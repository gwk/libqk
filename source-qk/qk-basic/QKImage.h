// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKPixFmt.h"
#import "QKData.h"


@interface QKImage : NSObject <QKData>

@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, readonly) V2I32 size;
@property (nonatomic, readonly) id<QKData> data;
@property (nonatomic, readonly) GLenum glDataFormat;
@property (nonatomic, readonly) GLenum glDataType;

- (const void*)bytes;
- (Int)length;
- (BOOL)isMutable;

- (id)initWithFormat:(QKPixFmt)format size:(V2I32)size data:(id<QKData>)data;
+ (id)withFormat:(QKPixFmt)format size:(V2I32)size data:(id<QKData>)data;

- (void)validate;

@end


