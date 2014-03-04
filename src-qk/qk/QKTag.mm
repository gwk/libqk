// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKTag.h"


@implementation QKTag


DEF_INIT(Tag:(int)tag obj:(id)obj) {
  INIT(super init);
  _tag = tag;
  _obj = obj;
  return self;
}


@end
