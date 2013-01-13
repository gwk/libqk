// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSData+QK.h"
#import "NSString+QK.h"
#import "QKStructArray.h"


@implementation QKStructArray


- (NSString*)description {
  return [NSString withFormat:@"<QKStructArray %p: es:%lu count:%lu>", self, self.elSize, self.count];
}


// mutable subclass overrides this.
+ (NSData *)copyData:(NSData*)data {
  return data.copy;
}


- (id)initWithElSize:(Int)elSize data:(NSData*)data {
  INIT(super init);
  _elSize = elSize;
  _data = [self.class copyData:data];
  return self;
}


+ (id)withElSize:(Int)elSize data:(NSData*)data {
  return [[self alloc] initWithElSize:elSize data:data];
}


+ (id)withElSize:(Int)elSize {
  return [self withElSize:elSize data:nil];
}


+ (id)withElSize:(Int)elSize bytes:(void*)bytes length:(Int)length {
  return [self withElSize:elSize data:[NSData dataWithBytes:bytes length:length]];
}


+ (id)withElSize:(Int)elSize structArray:(QKStructArray*)structArray copyBlock:(BlockStructCopy)block {
  NSMutableData* data = [NSMutableData dataWithLength:elSize * structArray.count];
  void* to = data.mutableBytes;
  const void* from = structArray.bytes;
  const void* end = structArray.bytesEnd;
  size_t fromElSize = structArray.elSize;
  
  BlockStructCopyActual b = block;
  while (from < end) {
    b(to, from);
    to += elSize;
    from += fromElSize;
  }
  return [self withElSize:elSize data:data];
}


+ (id)withElSize:(Int)elSize structArray:(QKStructArray*)structArray filterCopyBlock:(BlockStructFilterCopy)block {
  NSMutableData* data = [NSMutableData dataWithLength:elSize * structArray.count];
  void* to = data.mutableBytes;
  const void* from = structArray.bytes;
  const void* end = structArray.bytesEnd;
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
  return [self withElSize:elSize data:data];
}


+ (id)join:(NSArray*)arrays {
  int elSize = [arrays.el0OrNil elSize];
  if (!QK_OPTIMIZE) {
    for (QKStructArray* el in arrays) {
      assert(el.elSize == elSize, @"mismatched elSize: %@; %@", arrays.el0, el);
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
  return _data.bytes + _data.length;
}


- (NSRange)byteRange:(NSRange)range {
  return NSRangeMake(range.location * _elSize, range.length * _elSize);
}


- (void)get:(int)index to:(void*)to {
  assert(index < self.count, @"bad index: %d; %@", index, self);
  const void* ptr = _data.bytes + index * _elSize;
  memmove(to, ptr, _elSize);
}


- (id)copyWithZone:(NSZone*)zone {
  return self;
}


- (id)mutableCopyWithZone:(NSZone*)zone {
  return [QKMutableStructArray withElSize:_elSize data:_data];
}


- (QKStructArray*)subWithRange:(NSRange)range {
  return [QKStructArray withElSize:_elSize data:[_data subdataWithRange:[self byteRange:range]]];
}


- (void)step:(BlockStepStruct)block {
  const void* p = _data.bytes;
  const void* end = p + _data.length;
  BlockStepStructActual b = block;
  while (p < end) {
    b(p);
  }
}

@end
