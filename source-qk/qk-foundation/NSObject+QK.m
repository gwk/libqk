// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKImage.h"
#import "NSObject+QK.h"


NSString* const QKDErrorDomain = @"QKDErrorDomain";


void  executeAsync(BlockExecute asyncBlock, BlockDo syncBlock) {
  
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


@implementation NSObject (Oro)


- (void)dissolve {}


@end
