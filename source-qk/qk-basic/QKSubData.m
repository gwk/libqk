// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKSubData.h"


@interface QKSubData ()
@end


@implementation QKSubData


- (id)initWithData:(NSData*)data offset:(Int)offset length:(Int)length mapped:(BOOL)mapped {
  check(offset + length <= data.length,
        @"out of bounds: data.length: %lu; offset: %ld; length: %ld", (unsigned long)data.length, offset, length);
  INIT(super init);
  _data = data;
  _bytes = data.bytes + offset;
  _length = length;
  _isDataMapped = mapped;
  return self;
}


+ (id)withData:(NSData*)data offset:(Int)offset length:(Int)length mapped:(BOOL)mapped {
  return [[self alloc] initWithData:data offset:offset length:length mapped:mapped];
}


- (BOOL)isDataMutable {
  return IS_KIND(_data, NSMutableData);
}


@end

