// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKImage.h"


@interface QKImage ()
@end


@implementation QKImage


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: %@ %@>", self.class, self, QKPixFmtDesc(_format), V2I32Desc(_size)];
}


- (id)initWithHeader:(NSDictionary*)header data:(QKSubData*)data error:(NSError**)errorPtr {
  INIT(super init);
  _data = data;
  _size = (V2I32){ [[header objectForKey:@"width"] intValue], [[header objectForKey:@"height"] intValue] };
  check(_size._[0] > 0 && _size._[1] > 0, @"bad size: %@", header);
  _format = QKPixFmtFromString([header objectForKey:@"format"]);
  if (!_format) {
    *errorPtr = [NSError withDomain:QKDErrorDomain code:QKDErrorCodeKeyMissing desc:@"bad/missing format" info:@{
                 @"header" : header }
                 ];
    return nil;
  }  
  return self;
}


- (GLenum)glDataFormat {
  return QKPixFmtGlDataFormat(_format);
}


- (GLenum)glDataType {
  return QKPixFmtGlDataType(_format);
}


@end

