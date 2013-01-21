// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Foundation/Foundation.h>


@interface NSMutableDictionary (QK)

- (void)setItem:(Duo*)item;
- (void)setItemIgnoreNil:(Duo*)item;

@end
