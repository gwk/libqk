// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


extern NSString* const QKJsonErrorDomain;

typedef enum {
  QKJsonErrorCodeUnknown = 0,
  QKJsonErrorCodeUnexpectedRootType,
} QKJsonErrorCode;


@interface NSData (QK)

+ (id)join:(NSArray*)array;
+ (id)withPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (id)withPath:(NSString*)path map:(BOOL)map;
+ (id)named:(NSString *)resourceName;


- (id)dictFromJsonWithError:(NSError **)errorPtr;
- (id)arrayFromJsonWithError:(NSError **)errorPtr;

@end

