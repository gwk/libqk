// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKData.h"


@interface NSData (QK) <QKData>

+ (id)join:(NSArray*)array;
+ (id)withPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (id)withPath:(NSString*)path map:(BOOL)map;
+ (id)named:(NSString *)resourceName;

- (id)dictFromJsonWithError:(NSError **)errorPtr;
- (id)arrayFromJsonWithError:(NSError **)errorPtr;

@end

