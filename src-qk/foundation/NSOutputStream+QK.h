// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKData.h"


@interface NSOutputStream (QK)

- (Int)writeData:(id<QKData>)data;

@end

