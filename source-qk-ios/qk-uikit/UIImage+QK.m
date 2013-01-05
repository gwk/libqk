// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIImage+QK.h"


@implementation UIImage (QK)


+ (UIImage *)named:(NSString*)name {
    assert(name, @"nil image name");    
    UIImage* image = [self imageNamed:name];
    assert(image, @"no image for name: %@", name);
    return image;
}


@end
