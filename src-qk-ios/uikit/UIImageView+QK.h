// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKLitView.h"


@interface UIImageView (QK) <QKLitView>

+ (instancetype)withImage:(UIImage *)image;
+ (instancetype)withImageNamed:(NSString *)name;

@end
