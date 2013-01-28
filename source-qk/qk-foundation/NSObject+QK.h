// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Foundation/Foundation.h>
#import "qk-block-types.h"


extern NSString* const QKDErrorDomain;

typedef enum {
  QKDErrorCodeUnknown = 0,
  QKDErrorCodeTypeMissing,    // "type" item is missing from header.
  QKDErrorCodeTypeUnkown,     // "type" item has bad value.
  QKDErrorCodeTypeUnexpected, // type is valid, but does not match calling class.
  QKDErrorCodeKeyMissing,     // arbitrary key is required but missing.
  QKDErrorCodeDataMissing,
} QKDErrorCode;


void  executeAsync(BlockExecute asyncBlock, BlockDo syncBlock);


@interface NSObject (Oro)

- (void)dissolve;

// participating classes must override this.
- (id)initWithHeader:(NSDictionary*)header data:(QKSubData*)data error:(NSError**)errorPtr;

+ (id)withQkdPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (id)withQkdNamed:(NSString*)resourceName;

@end
