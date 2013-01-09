// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKStructArray.h"


@interface QKMutableStructArray : QKStructArray

@property (nonatomic, readonly) void* mutableBytes;

- (void)appendElement:(void*)element;

- (void)replaceElementsInRange:(NSRange)range withBytes:(const void*)bytes count:(Int)count;
- (void)removeElementsInRange:(NSRange)range;

@end
