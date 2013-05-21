// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Foundation/Foundation.h>


@interface QKDuo : NSObject

@property (nonatomic) id a;
@property (nonatomic) id b;

+ (QKDuo*)a:(id)a b:(id)b;

@end
