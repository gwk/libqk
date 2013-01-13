// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Foundation/Foundation.h>


// clang does not automatically cast between block types with specific pointer types and void pointers.
typedef void (^BlockStepStructActual)(const void*);
typedef id BlockStepStruct;

typedef void (^BlockStructCopyActual)(void*, const void*);
typedef id BlockStructCopy;

typedef BOOL (^BlockStructFilterCopyActual)(void*, const void*);
typedef id BlockStructFilterCopy;

@interface QKStructArray : NSObject <NSMutableCopying>

@property (nonatomic, readonly) Int elSize;
@property (nonatomic, readonly) Int count;
@property (nonatomic, readonly) Int length;
@property (nonatomic, readonly) NSData* data;
@property (nonatomic, readonly) const void* bytes;
@property (nonatomic, readonly) const void* bytesEnd;


- (id)initWithElSize:(Int)elSize data:(NSData*)data;
+ (id)withElSize:(Int)elSize;
+ (id)withElSize:(Int)elSize data:(NSData*)data;
+ (id)withElSize:(Int)elSize bytes:(void*)bytes length:(Int)length;
+ (id)withElSize:(Int)elSize structArray:(QKStructArray*)structArray copyBlock:(BlockStructCopy)block;
+ (id)withElSize:(Int)elSize structArray:(QKStructArray*)structArray filterCopyBlock:(BlockStructFilterCopy)block;

+ (id)join:(NSArray*)arrays;

- (Int)lastIndex;

- (QKStructArray*)subWithRange:(NSRange)range;

- (NSRange)byteRange:(NSRange)range;

- (void)get:(int)index to:(void*)to;

- (void)step:(BlockStepStruct)block;

@end
