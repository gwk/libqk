// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UIImage+QK.h"
#import "UIImageView+QK.h"


@interface QKImageView : UIImageView

@property (nonatomic) UIImage* placeholder;

- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform;

@end

