// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UIButton+QK.h"


@implementation UIButton (QK)


+ (instancetype)withFrame:(CGRect)frame
                     flex:(UIFlex)flex
                   target:(id)target
                   action:(SEL)action
                    title:(NSString*)title {
  
  UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  b.frame = frame;
  b.autoresizingMask = flex;
  [b addTarget:target action:action];
  b.title = title;
  return b;
}


- (UIImage*)image {
  return [self imageForState:UIControlStateNormal];
}


- (void)setImage:(UIImage*)image {
  [self setImage:image forState:UIControlStateNormal];
}


- (NSString*)title {
  return [self titleForState:UIControlStateNormal];
}


- (void)setTitle:(NSString *)title {
  [self setTitle:title forState:UIControlStateNormal];
}


- (NSAttributedString*)attrTitle {
  return [self attributedTitleForState:UIControlStateNormal];
}


- (void)setAttrTitle:(NSAttributedString*)attrTitle {
  [self setAttributedTitle:attrTitle forState:UIControlStateNormal];
}


- (UIColor*)titleColor {
  return [self titleColorForState:UIControlStateNormal];
}


- (void)setTitleColor:(UIColor *)color {
  [self setTitleColor:color forState:UIControlStateNormal];
}


- (void)addTarget:(id)target action:(SEL)action {
  [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end

