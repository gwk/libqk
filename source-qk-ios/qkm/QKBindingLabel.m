// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKBinding.h"
#import "QKBindingLabel.h"


@interface QKBindingLabel ()

@property (nonatomic) QKBinding* binding;

@end


@implementation QKBindingLabel


#pragma mark - UILabel


- (void)setText:(NSString*)text {
  if (text) {
    self.enabled = YES;
  }
  else {
    text = _placeholderText;
    self.enabled = NO;
  }
  [super setText:text];
}


#pragma  mark - QKBindingLabel


- (void)setPlaceholderText:(NSString*)placeholderText {
  _placeholderText = placeholderText;
  if (!self.text) {
    self.enabled = NO;
    [super setText:placeholderText];
  }
}


- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform {
  self.binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"text" transform:viewTransform];
}


@end
