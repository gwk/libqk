// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"


@protocol QKData <NSObject>

- (const void*)bytes;
- (Int)length;
- (BOOL)isMutable;

@end


@interface NSObject (QKData)

- (NSMutableData*)mutableRowPointersForElSize:(I32)elSize width:(Int)width;
- (NSData*)rowPointersForElSize:(I32)elSize width:(Int)width;

- (NSString *)debugDataString:(Int)limit;
- (NSString *)debugDataString;

@end


