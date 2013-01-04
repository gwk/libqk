// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"


// return the string if it is not nil, otherwise return the blank string
#define STRING_OR_BLANK(str) \
({ NSString* _str = (str); _str ? _str : @""; })

// return the string preceded by a space if not nil, otherwise the blank string
#define STRING_WITH_SPACE_PREFIX_OR_BLANK(str) \
({ NSString* _str = (str); _str ? [@" " stringByAppendingString:_str] : @""; })


@interface NSString (Oro)

+ (id)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

+ (id)withUtf8:(Utf8)string;
+ (id)withUtf32:(Utf32)string;

+ (id)withUtf8M:(Utf8M)string free:(BOOL)free;
+ (id)withUtf32M:(Utf32M)string free:(BOOL)free;

- (Utf8)asUtf8 NS_RETURNS_INNER_POINTER; // alias of UTF8String
- (Utf32)asUtf32 NS_RETURNS_INNER_POINTER;

- (Utf8M)asUtf8M; // mallocs a copy of Utf8
- (Utf32M)asUtf32M; // mallocs a copy of Utf32

@end


// autoreleased copies of strings
Utf8 Utf8AR(Utf8 string);
Utf32 Utf32AR(Utf32 string);

Utf32 Utf32With8(Utf8 string);
Utf8 Utf8With32(Utf32 string);

Utf32 Utf32MWith8(Utf8 string);
Utf8 Utf8MWith32(Utf32 string);
