// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-vec.h"
#import "QKPixFmt.h"
#import "QKData.h"

typedef unsigned int GLenum;

@interface QKImage : NSObject <QKData>

@property (nonatomic, readonly) QKPixFmt format;
@property (nonatomic, readonly) V2I32 size;
@property (nonatomic, readonly) NSMutableData* data; // underlying data.
@property (nonatomic, readonly) NSMutableDictionary* meta; // metadata, e.g. jpeg exif.

+ (NSDictionary*)propertiesForImageAtPath:(NSString*)path;

- (const void*)bytes;
- (void*)mutableBytes;
- (Int)length;
- (BOOL)isMutable;

- (NSString*)formatDesc;
- (GLenum)glDataFormat;
- (GLenum)glDataType;

DEC_INIT(Format:(QKPixFmt)format size:(V2I32)size data:(NSMutableData*)data meta:(NSMutableDictionary*)meta);
DEC_INIT(Path:(NSString*)path map:(BOOL)map fmt:(QKPixFmt)fmt error:(NSError**)errorPtr);

+ (QKImage*)named:(NSString*)resourceName fmt:(QKPixFmt)fmt;

- (void)validate;
- (void)transpose;
- (void)flipH;
- (void)rotateQCW;

#if TARGET_OS_IPHONE
- (UIImage*)uiImage;
#endif

@end
