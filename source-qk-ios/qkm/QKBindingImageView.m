// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKBinding.h"
#import "QKBindingImageView.h"


@interface QKBindingImageView ()

@property (nonatomic) QKBinding* binding;

@end


@implementation QKBindingImageView


#pragma mark - UILabel


- (void)setImage:(UIImage*)image {
  [super setImage:LIVE_ELSE(image, _placeholderImage)];
}


#pragma  mark - QKBindingLabel


- (void)setPlaceholderImage:(UIImage*)placeholderImage {
  _placeholderImage = placeholderImage;
  if (!self.image) {
    [super setImage:placeholderImage];
  }
}


- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform {
  self.binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"image" transform:viewTransform];
}




@end

