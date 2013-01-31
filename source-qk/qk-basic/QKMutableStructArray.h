// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKStructArray.h"


@interface QKMutableStructArray : QKStructArray

@property (nonatomic, readonly) void* mutableBytes;
@property (nonatomic, readonly) void* mutableBytesEnd;


- (void)replaceElementsInRange:(NSRange)range withBytes:(const void*)bytes count:(Int)count;
- (void)removeElementsInRange:(NSRange)range;

- (void)setEl:(int)index from:(void*)from;
- (void)appendElement:(const void*)element;

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

#undef EL

@end
