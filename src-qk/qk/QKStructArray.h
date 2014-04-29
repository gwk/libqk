// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-types.h"
#import "qk-vec.h"
#import "QKData.h"


// clang does not automatically cast between block types with specific pointer types and void pointers,
// so we loosely type BlockStruct arguments and then cast to the expected void* type internally.
typedef void (^BlockStructStepActual)(const void*); // from
typedef id BlockStructStep;

typedef void (^BlockStructCopyActual)(void*, const void*); // to, from
typedef id BlockStructCopy;

typedef BOOL (^BlockStructFilterCopyActual)(void*, const void*); // to, from
typedef id BlockStructFilterCopy;

typedef void (^BlockStructMapIntActual)(void*, Int); // to, index
typedef id BlockStructMapInt;


@interface QKStructArray : NSObject <NSMutableCopying, QKData>

@property (nonatomic, readonly) I32 elSize;
@property (nonatomic, readonly) Int count; // element count
@property (nonatomic, readonly) Int length; // data length in bytes
@property (nonatomic, readonly) NSData* data;
@property (nonatomic, readonly) const void* bytes;
@property (nonatomic, readonly) const void* bytesEnd;

DEC_INIT(ElSize:(I32)elSize);
DEC_INIT(ElSize:(I32)elSize data:(NSData*)data);
DEC_INIT(ElSize:(I32)elSize bytes:(void*)bytes length:(Int)length);
DEC_INIT(ElSize:(I32)elSize from:(Int)from to:(Int)to mapIntBlock:(BlockStructMapInt)block);
DEC_INIT(ElSize:(I32)elSize structArray:(QKStructArray*)structArray copyBlock:(BlockStructCopy)block);
DEC_INIT(ElSize:(I32)elSize structArray:(QKStructArray*)structArray filterCopyBlock:(BlockStructFilterCopy)block);

- (NSData*)rowPointersForWidth:(Int)width;
- (NSMutableData*)mutableRowPointersForWidth:(Int)width;

+ (id)join:(NSArray*)arrays;

- (Int)lastIndex;

- (QKStructArray*)subWithRange:(NSRange)range;

- (NSRange)byteRange:(NSRange)range;
- (NSRange)byteRangeForIndex:(Int)index;

- (void)el:(Int)index to:(void*)to;
- (Int)elInt:(Int)index;
- (I32)elI32:(Int)index;
- (I64)elI64:(Int)index;
- (F32)elF32:(Int)index;
- (F64)elF64:(Int)index;
- (V2F32)elV2F32:(Int)index;
- (V2F64)elV2F64:(Int)index;

- (void)step:(BlockStructStep)block;

@end
