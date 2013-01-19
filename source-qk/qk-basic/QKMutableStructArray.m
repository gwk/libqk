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


- (void)appendElement:(const void*)element {
  [self.mutableData appendBytes:element length:self.elSize];
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


#define SET_EL(T) \
- (void)setEl:(int)index T:(T)val { \
assert(self.elSize == sizeof(T), @"bad type: %s", #T); \
ASSERT_INDEX; \
[self.mutableData replaceBytesInRange:[self byteRangeForIndex:index] withBytes:&val]; \
} \


SET_EL(Int);
SET_EL(I32);
SET_EL(I64);
SET_EL(F32);
SET_EL(F64);
SET_EL(V2F32);
SET_EL(V2F64);




@end
