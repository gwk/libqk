// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"


@interface QKTag : NSObject

@property (nonatomic) int tag;
@property (nonatomic) id obj;

DEC_INIT(Tag:(int)tag obj:(id)obj);

@end
