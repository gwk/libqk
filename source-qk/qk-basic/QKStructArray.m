// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"
#import "QKStructArray.h"


@implementation QKStructArray


- (NSString*)description {
  return [NSString withFormat:@"<QKStructArray %p: es:%d count:%d>", self, self.elSize, self.count];
}


- (id)initWithElSize:(Int)elSize data:(NSData*)data {
  INIT(super init);
  _elSize = elSize;
  _data = data;
  return self;
}


+ (id)withElSize:(Int)elSize data:(NSData*)data {
  return [[self alloc] initWithElSize:elSize data:data];
}


+ (id)withElSize:(Int)elSize bytes:(void*)bytes length:(Int)length {
  return [self withElSize:elSize data:[NSData dataWithBytes:bytes length:length]];
}


+ (id)withElSize:(Int)elSize structArray:(QKStructArray*)structArray copyBlock:(BlockStructCopy)block {
  NSMutableData* data = [NSMutableData dataWithLength:elSize * structArray.count];
  void* to = data.mutableBytes;
  const void* from = structArray.bytes;
  const void* end = from + structArray.length;
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
  int count = 0;
  const void* from = structArray.bytes;
  const void* end = from + structArray.length;
  size_t fromElSize = structArray.elSize;
  
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



- (Int)count {
  return _data.length / _elSize;
}


- (Int)length {
  return _data.length;
}


- (const void*)bytes {
  return _data.bytes;
}


@end
