// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "UIImage+QK.h"
#import "UIImageView+QK.h"


@implementation UIImageView (QK)


#pragma mark - QKLitView


PROPERTY_ALIAS(BOOL, isLit, IsLit, self.highlighted);


#pragma mark - QK


+ (instancetype)withImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}


+ (instancetype)withImageNamed:(NSString *)name {
    return [[self alloc] initWithImage:[UIImage named:name]];
}


@end
