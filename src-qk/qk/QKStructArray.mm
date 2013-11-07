// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSArray+QK.h"
#import "NSData+QK.h"
#import "NSString+QK.h"
#import "QKStructArray.h"
#import "QKMutableStructArray.h"


@implementation QKStructArray


- (NSString*)description {
  return [NSString withFormat:@"<QKStructArray %p: es:%u count:%lu>", self, self.elSize, self.count];
}


- (BOOL)isMutable {
  return NO;
}


// mutable subclass overrides this.
+ (NSData *)copyData:(NSData*)data {
  return data.copy;
}


DEF_INIT(ElSize:(I32)elSize) {
  return [self initWithElSize:elSize data:nil];
}


DEF_INIT(ElSize:(I32)elSize data:(NSData*)data) {
  INIT(super init);
  _elSize = elSize;
  _data = [self.class copyData:data];
  return self;
}


DEF_INIT(ElSize:(I32)elSize bytes:(void*)bytes length:(Int)length) {
  return [self initWithElSize:elSize data:[NSData dataWithBytes:bytes length:length]];
}


DEF_INIT(ElSize:(I32)elSize from:(Int)from to:(Int)to mapIntBlock:(BlockStructMapInt)block) {
  Int count = to - from;
  NSMutableData* data = [NSMutableData dataWithLength:elSize * count];
  void* p = data.mutableBytes;
  BlockStructMapIntActual b = block;
  for_imn(i, from, to) {
    b(p, i);
    p = (U8*)p + elSize;
  }
  return [self initWithElSize:elSize data:data];
}


DEF_INIT(ElSize:(I32)elSize structArray:(QKStructArray*)structArray copyBlock:(BlockStructCopy)block) {
  NSMutableData* data = [NSMutableData dataWithLength:elSize * structArray.count];
  U8* to = (U8*)data.mutableBytes;
  const U8* from = (U8*)structArray.bytes;
  const U8* end = (U8*)structArray.bytesEnd;
  size_t fromElSize = structArray.elSize;
  
  BlockStructCopyActual b = block;
  while (from < end) {
    b(to, from);
    to += elSize;
    from += fromElSize;
  }
  return [self initWithElSize:elSize data:data];
}


DEF_INIT(ElSize:(I32)elSize structArray:(QKStructArray*)structArray filterCopyBlock:(BlockStructFilterCopy)block) {
  NSMutableData* data = [NSMutableData dataWithLength:elSize * structArray.count];
  U8* to = (U8*)data.mutableBytes;
  const U8* from = (U8*)structArray.bytes;
  const U8* end = (U8*)structArray.bytesEnd;
  size_t fromElSize = structArray.elSize;
  int count = 0;
  
  BlockStructFilterCopyActual b = block;
  while (from < end) {
    BOOL ok = b(to, from);
    if (ok) {
      to += elSize;
      count++;
    }
    from += fromElSize;
  }
  data.length = elSize * count;
  return [self initWithElSize:elSize data:data];
}


- (NSData*)rowPointersForWidth:(Int)width {
  return [self rowPointersForElSize:_elSize width:width];
}


- (NSMutableData*)mutableRowPointersForWidth:(Int)width {
  return [self mutableRowPointersForElSize:_elSize width:width];
}


+ (id)join:(NSArray*)arrays {
  if (!arrays.count) {
    return nil;
  }
  I32 elSize = [arrays.el0 elSize];
  if (!QK_OPTIMIZE) {
    for (QKStructArray* el in arrays) {
      qk_assert(el.elSize == elSize, @"mismatched elSize: %@; %@", arrays.el0, el);
    }
  }
  return [self withElSize:elSize data:[NSData join:[arrays map:^(QKStructArray* a){
    return a.data;
  }]]];
}


- (Int)count {
  return _data.length / _elSize;
}


- (Int)lastIndex {
  return self.count - 1;
}


- (Int)length {
  return _data.length;
}


- (const void*)bytes {
  return _data.bytes;
}


- (const void*)bytesEnd {
  return (U8*)_data.bytes + _data.length;
}


- (NSRange)byteRange:(NSRange)range {
  return NSRangeMake(range.location * _elSize, range.length * _elSize);
}


- (NSRange)byteRangeForIndex:(Int)index {
  return NSRangeMake(index * _elSize, _elSize);
}


#define ASSERT_INDEX qk_assert(index < self.count, @"bad index: %ld; %@", index, self)

- (void)el:(Int)index to:(void*)to {
  ASSERT_INDEX;
  const void* ptr = (U8*)_data.bytes + index * _elSize;
  memmove(to, ptr, _elSize);
}


#define EL(T) \
- (T)el##T:(Int)index { \
qk_assert(self.elSize == sizeof(T), @"bad type: %s", #T); \
ASSERT_INDEX; \
const T* p = (T*)_data.bytes; \
return p[index]; \
} \


EL(Int);
EL(I32);
EL(I64);
EL(F32);
EL(F64);
EL(V2F32);
EL(V2F64);


- (id)copyWithZone:(NSZone*)zone {
  return self;
}


- (id)mutableCopyWithZone:(NSZone*)zone {
  return [QKMutableStructArray withElSize:_elSize data:_data];
}


- (QKStructArray*)subWithRange:(NSRange)range {
  return [QKStructArray withElSize:_elSize data:[_data subdataWithRange:[self byteRange:range]]];
}


- (void)step:(BlockStructStep)block {
  const U8* p = (U8*)_data.bytes;
  const U8* end = (U8*)p + _data.length;
  BlockStructStepActual b = block;
  while (p < end) {
    b(p);
    p += _elSize;
  }
}

@end
