// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "Duo.h"


@implementation Duo

+ (id)a:(id)a b:(id)b {
  Duo* d = [self new];
  d.a = a;
  d.b = b;
  return d;
}

@end
