// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-vec.h"
#import "QKPixFmt.h"
#import "QKData.h"

typedef unsigned int GLenum;

@interface QKImage : NSObject <QKData>

@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, readonly) V2I32 size;
@property (nonatomic, readonly) id<QKData> data;

- (const void*)bytes;
- (Int)length;
- (BOOL)isMutable;

- (NSString*)formatDesc;
- (GLenum)glDataFormat;
- (GLenum)glDataType;

DEC_INIT(Format:(QKPixFmt)format size:(V2I32)size data:(id<QKData>)data);
DEC_INIT(Path:(NSString*)path map:(BOOL)map alpha:(BOOL)alpha error:(NSError**)errorPtr);

+ (QKImage*)named:(NSString*)resourceName alpha:(BOOL)alpha;

- (void)validate;

@end
