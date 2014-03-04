// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "QKBinding.h"
#import "QKImageView.h"


@interface QKImageView ()

@property (nonatomic) QKBinding* binding;

@end


@implementation QKImageView


#pragma mark - NSObject


DEF_DEALLOC_DISSOLVE {
  DISSOLVE(_binding);
}


#pragma mark - UILabel


- (void)setImage:(UIImage*)image {
  [super setImage:LIVE_ELSE(image, _placeholder)];
}


#pragma  mark - QKBindingLabel


- (void)setPlaceholder:(UIImage*)placeholder {
  _placeholder = placeholder;
  if (!self.image) {
    [super setImage:placeholder];
  }
}


- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform {
  _binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"image" transform:viewTransform];
}




@end

