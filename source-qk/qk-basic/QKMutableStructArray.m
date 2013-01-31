// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKMutableStructArray.h"


@implementation QKMutableStructArray


// override creates mutable copy
+ (NSData *)copyData:(NSData*)data {
  return data ? data.mutableCopy : [NSMutableData new];
}



- (NSMutableData*)mutableData {
  return CAST(NSMutableData, self.data);
}


- (void*)mutableBytes {
  return self.mutableData.mutableBytes;
}


- (void*)mutableBytesEnd {
  return self.mutableData.mutableBytes + self.length;
}


- (id)copyWithZone:(NSZone*)zone {
  return [QKStructArray withElSize:self.elSize data:self.data];
}


- (void)replaceElementsInRange:(NSRange)range withBytes:(const void*)bytes count:(Int)count {
  [self.mutableData replaceBytesInRange:[self byteRange:range]
                              withBytes:bytes
                                 length:count * self.elSize];
}


- (void)removeElementsInRange:(NSRange)range {
  [self replaceElementsInRange:range withBytes:NULL count:0];
}


#define ASSERT_INDEX assert(index < self.count, @"bad index: %d; %@", index, self)

- (void)setEl:(int)index from:(void*)from {
  ASSERT_INDEX;
  [self.mutableData replaceBytesInRange:[self byteRangeForIndex:index] withBytes:from];
}


- (void)appendElement:(const void*)element {
  [self.mutableData appendBytes:element length:self.elSize];
}


#define EL(T) \
- (void)setEl:(int)index T:(T)element { \
assert(self.elSize == sizeof(T), @"bad type: %s", #T); \
ASSERT_INDEX; \
[self.mutableData replaceBytesInRange:[self byteRangeForIndex:index] withBytes:&element]; \
} \
\
- (void)append##T:(T)element { \
assert(self.elSize == sizeof(T), @"bad type: %s", #T); \
[self.mutableData appendBytes:&element length:self.elSize]; \
} \


EL(Int);
EL(I32);
EL(I64);
EL(F32);
EL(F64);
EL(V2F32);
EL(V2F64);

#undef EL


@end
