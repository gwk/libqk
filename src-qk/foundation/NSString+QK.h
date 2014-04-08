// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-types.h"
#import "qk-block-types.h"


#define fmt(...) [NSString stringWithFormat:__VA_ARGS__]

// return the string if it is not nil, otherwise return the blank string
#define STRING_OR_EMPTY(str) \
({ NSString* _str = (str); _str ? _str : @""; })

// return the string preceded by a space if not nil, otherwise the blank string
#define STRING_WITH_SPACE_PREFIX_OR_EMPTY(str) \
({ NSString* _str = (str); _str ? [@" " stringByAppendingString:_str] : @""; })


@interface NSString (QK)

+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

+ (instancetype)withUtf8:(Utf8)string;
+ (instancetype)withUtf32:(Utf32)string;

+ (instancetype)withUtf8M:(Utf8M)string free:(BOOL)free;
+ (instancetype)withUtf32M:(Utf32M)string free:(BOOL)free;

- (Utf8)asUtf8 NS_RETURNS_INNER_POINTER; // alias of UTF8String
- (Utf32)asUtf32 NS_RETURNS_INNER_POINTER;

- (Utf8M)asUtf8M; // mallocs a copy of Utf8
- (Utf32M)asUtf32M; // mallocs a copy of Utf32

- (Int)lineCount;
- (NSString*)numberedLinesFrom:(Int)from;
- (NSString*)numberedLines;
- (NSString*)numberedLinesFrom0;

- (void)walkPathDeep:(BlockDoString)block;

#if TARGET_OS_IPHONE

+ (NSDictionary*)attributesForFont:(UIFont*)font
                         lineBreak:(NSLineBreakMode)lineBreak
                         alignment:(NSTextAlignment)alignment;

- (CGSize)sizeForFont:(UIFont*)font
            lineBreak:(NSLineBreakMode)lineBreak
                    w:(CGFloat)w
                    h:(CGFloat)h;

- (CGFloat)widthForFont:(UIFont*)font lineBreak:(NSLineBreakMode)lineBreak w:(CGFloat)w;

- (CGFloat)heightForFont:(UIFont*)font
               lineBreak:(NSLineBreakMode)lineBreak
                       w:(CGFloat)w
                       h:(CGFloat)h
                 lineMin:(int)lineMin;

- (void)drawInRect:(CGRect)rect
              font:(UIFont*)font
         lineBreak:(NSLineBreakMode)lineBreak
         alignment:(NSTextAlignment)alignment;

#endif // TARGET_OS_IPHONE

@end


#ifdef __cplusplus

// autoreleased copies of strings
Utf8 Utf8AR(Utf8 string);
Utf32 Utf32AR(Utf32 string);

Utf32 Utf32With8(Utf8 string);
Utf8 Utf8With32(Utf32 string);

Utf32 Utf32MWith8(Utf8 string);
Utf8 Utf8MWith32(Utf32 string);

#endif // __cplusplus