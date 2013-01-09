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


- (void)appendElement:(void*)element {
  [self.mutableData appendBytes:element length:self.elSize];
}


@end
