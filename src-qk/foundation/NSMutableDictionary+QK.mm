// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKDuo.h"
#import "NSMutableDictionary+QK.h"


@implementation NSMutableDictionary (QK)


- (void)setItem:(QKDuo*)item {
  [self setObject:item.b forKey:item.a];
}


- (void)setItemIgnoreNil:(QKDuo*)item {
  if (item.a && item.b) {
    [self setObject:item.b forKey:item.a];
  }
}


- (id)setDefault:(id)defaultVal forKey:(id)key {
  id val = self[key];
  if (val) {
    return val;
  }
  self[key] = defaultVal;
  return defaultVal;
}


- (id)setDefaultWithClass:(Class)defaultClass forKey:(id)key {
  id val = self[key];
  if (val) {
    return val;
  }
  val = [defaultClass new];
  self[key] = val;
  return val;
}



- (BOOL)isMutable {
  return YES;
}


@end
