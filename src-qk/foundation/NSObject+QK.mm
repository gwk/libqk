// Copyright 2012 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-log.h"
#import "NSObject+QK.h"


void  executeAsync(BlockCompute asyncBlock, BlockDo syncBlock) {
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    id result;
    @try {
      result = asyncBlock();
    }
    @catch (NSException* e) {
      dispatch_async(dispatch_get_main_queue(), ^{
        errFL(@"exception during executeAsync: %@\n%@", e, e.callStackSymbols);
        [e raise];
      });
      return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      syncBlock(result);
    });
  });
}


@implementation NSObject (QK)


- (void)dissolve {}


@end
