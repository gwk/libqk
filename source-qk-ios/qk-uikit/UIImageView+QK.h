// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKHighlightingView.h"


@interface UIImageView (QK) <QKHighlightingView>

+ (id)withImage:(UIImage *)image;
+ (id)withImageNamed:(NSString *)name;

@end
