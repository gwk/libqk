// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "QKSubData.h"


@interface QKSubData ()
@end


@implementation QKSubData


- (id)initWithData:(id<QKData>)data offset:(Int)offset length:(Int)length {
  qk_check(offset + length <= data.length,
        @"out of bounds: data.length: %lu; offset: %ld; length: %ld", (unsigned long)data.length, offset, length);
  INIT(super init);
  _data = data;
  _bytes = (void*)((U8*)data.bytes + offset);
  _length = length;
  return self;
}


+ (id)withData:(id<QKData>)data offset:(Int)offset length:(Int)length {
  return [[self alloc] initWithData:data offset:offset length:length];
}


- (BOOL)isMutable {
  return _data.isMutable;
}


@end

