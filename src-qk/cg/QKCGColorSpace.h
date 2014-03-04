// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKPixFmt.h"
#import "QKCFObject.h"


@interface QKCGColorSpace : QKCFObject

+ (QKCGColorSpace*)w;
+ (QKCGColorSpace*)rgb;
+ (QKCGColorSpace*)rgb:(BOOL)rgb;
+ (QKCGColorSpace*)withFormat:(QKPixFmt)format;

@end

