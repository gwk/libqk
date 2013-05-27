// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIImage+QK.h"
#import "qk-check.h"


@implementation UIImage (QK)


+ (UIImage *)named:(NSString*)name {
    qk_assert(name, @"nil image name");    
    UIImage* image = [self imageNamed:name];
    qk_assert(image, @"no image for name: %@", name);
    return image;
}


@end
