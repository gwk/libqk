// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIButton+QK.h"


@implementation UIButton (QK)


+ (id)withFrame:(CGRect)frame
           flex:(UIFlex)flex
         target:(id)target
         action:(SEL)action
          title:(NSString*)title {
  
  UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  b.frame = frame;
  b.autoresizingMask = flex;
  [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  b.title = title;
  return b;
}


- (NSString*)title {
  return [self titleForState:UIControlStateNormal];
}


- (void)setTitle:(NSString *)title {
  [self setTitle:title forState:UIControlStateNormal];
}


@end

