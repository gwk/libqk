// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKBinding.h"
#import "QKLabel.h"


@interface QKLabel ()

@property (nonatomic) QKBinding* binding;

@end


@implementation QKLabel


#pragma mark - NSObject


DEF_DEALLOC_DISSOLVE {
  DISSOLVE(_binding);
}


#pragma mark - UILabel


- (void)setText:(NSString*)text {
  if (text) {
    self.enabled = YES;
  }
  else {
    text = _placeholder;
    self.enabled = NO;
  }
  [super setText:text];
}


#pragma  mark - QKBindingLabel


- (void)setPlaceholder:(NSString*)placeholder {
  _placeholder = placeholder;
  if (!self.text) {
    self.enabled = NO;
    [super setText:placeholder];
  }
}


- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform {
  _binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"text" transform:viewTransform];
}


@end
