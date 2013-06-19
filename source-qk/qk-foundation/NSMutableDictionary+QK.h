// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKDuo.h"


@interface NSMutableDictionary (QK)

- (void)setItem:(QKDuo*)item;
- (void)setItemIgnoreNil:(QKDuo*)item;

- (id)setDefault:(id)defaultVal forKey:(id)key;
- (id)setDefaultClass:(Class)defaultClass forKey:(id)key;

@end
