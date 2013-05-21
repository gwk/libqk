// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKDuo.h"


@interface NSMutableDictionary (QK)

- (void)setItem:(QKDuo*)item;
- (void)setItemIgnoreNil:(QKDuo*)item;

@end
