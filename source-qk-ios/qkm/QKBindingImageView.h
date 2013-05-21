// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKBindingImageView : UIImageView

@property (nonatomic) UIImage* placeholderImage;

- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform;

@end

