// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKStructArray.h"


@interface QKMutableStructArray : QKStructArray

@property (nonatomic, readonly) void* mutableBytes;
@property (nonatomic, readonly) void* mutableBytesEnd;

- (void)appendElement:(void*)element;

- (void)replaceElementsInRange:(NSRange)range withBytes:(const void*)bytes count:(Int)count;
- (void)removeElementsInRange:(NSRange)range;

- (void)setEl:(int)index from:(void*)from;
- (void)setEl:(int)index Int:(Int)val;
- (void)setEl:(int)index I32:(I32)val;
- (void)setEl:(int)index I64:(I64)val;
- (void)setEl:(int)index F32:(F32)val;
- (void)setEl:(int)index F64:(F64)val;
- (void)setEl:(int)index V2F32:(V2F32)val;
- (void)setEl:(int)index V2F64:(V2F64)val;

@end
