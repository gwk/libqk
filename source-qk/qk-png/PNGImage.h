// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface PNGImage : NSObject

@property (nonatomic, readonly) V2I32 size;
@property (nonatomic, readonly) NSData* data;
@property (nonatomic, readonly) int bitDepth;
@property (nonatomic, readonly) int colorType;
@property (nonatomic, readonly) int interlaceType;
@property (nonatomic, readonly) int compressionType;
@property (nonatomic, readonly) int filterType;
@property (nonatomic, readonly) int channels;
@property (nonatomic, readonly) Int rowByteSize;
@property (nonatomic, readonly) BOOL hasRGB;
@property (nonatomic, readonly) BOOL hasAlpha;
@property (nonatomic, readonly) V3U8 backgroundColor;

+ (PNGImage*)named:(NSString*)resourceName alpha:(BOOL)alpha;

@end

