// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKData.h"


@interface NSData (QK) <QKData>

+ (instancetype)join:(NSArray*)array;
+ (instancetype)withPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (instancetype)withPath:(NSString*)path map:(BOOL)map;
+ (instancetype)named:(NSString *)resourceName;

- (id)dictFromJsonWithError:(NSError **)errorPtr;
- (id)arrayFromJsonWithError:(NSError **)errorPtr;

@end

