// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKLitView.h"


@interface UIImageView (QK) <QKLitView>

+ (id)withImage:(UIImage *)image;
+ (id)withImageNamed:(NSString *)name;

@end
