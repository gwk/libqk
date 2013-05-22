// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKImageView : UIImageView

@property (nonatomic) UIImage* placeholder;

- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform;

@end

