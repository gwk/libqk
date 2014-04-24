// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKStructArray.h"


@interface QKMutableStructArray : QKStructArray

@property (nonatomic, readwrite) Int count; // element count
@property (nonatomic, readonly) void* mutableBytes;
@property (nonatomic, readonly) void* mutableBytesEnd;


DEC_INIT(ElSize:(I32)elSize count:(Int)count);

- (void)clear;
- (void)resetWithElSize:(I32)elSize;

- (void)replaceElementsInRange:(NSRange)range withBytes:(const void*)bytes count:(Int)count;
- (void)removeElementsInRange:(NSRange)range;

- (void)setEl:(int)index from:(void*)from;
- (void)appendEl:(const void*)element;

#define EL(T) \
- (void)setEl:(int)index T:(T)element; \
- (void)append##T:(T)element;

EL(Int);
EL(I32);
EL(I64);
EL(F32);
EL(F64);
EL(V2F32);
EL(V2F64);
EL(V3U16);
EL(V3F32);
EL(V3F64);

#undef EL

@end
