// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Foundation/Foundation.h>
#import "qk-block-types.h"


void  executeAsync(BlockCompute asyncBlock, BlockDo syncBlock);


@interface NSObject (QK)

- (void)dissolve;

@end
