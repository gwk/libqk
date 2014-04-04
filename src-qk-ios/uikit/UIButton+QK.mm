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


- (UIImage*)backgroundImage {
  return [self backgroundImageForState:UIControlStateNormal];
}


- (void)setBackgroundImage:(UIImage*)image {
  [self setBackgroundImage:image forState:UIControlStateNormal];
}


- (UIImage*)litBackgroundImage {
  return [self backgroundImageForState:UIControlStateHighlighted];
}


- (void)setLitBackgroundImage:(UIImage*)image {
  [self setBackgroundImage:image forState:UIControlStateHighlighted];
}


- (UIImage*)disabledBackgroundImage {
  return [self backgroundImageForState:UIControlStateDisabled];
}


- (void)setDisabledBackgroundImage:(UIImage*)image {
  [self setBackgroundImage:image forState:UIControlStateDisabled];
}


- (NSString*)title {
  return [self titleForState:UIControlStateNormal];
}


- (void)setTitle:(NSString *)title {
  [self setTitle:title forState:UIControlStateNormal];
}


- (NSString*)litTitle {
  return [self titleForState:UIControlStateHighlighted];
}


- (void)setLitTitle:(NSString *)title {
  [self setTitle:title forState:UIControlStateHighlighted];
}


- (NSAttributedString*)attrTitle {
  return [self attributedTitleForState:UIControlStateNormal];
}


- (void)setAttrTitle:(NSAttributedString*)attrTitle {
  [self setAttributedTitle:attrTitle forState:UIControlStateNormal];
}


- (NSAttributedString*)litAttrTitle {
  return [self attributedTitleForState:UIControlStateHighlighted];
}


- (void)setLitAttrTitle:(NSAttributedString*)attrTitle {
  [self setAttributedTitle:attrTitle forState:UIControlStateHighlighted];
}


- (UIColor*)titleColor {
  return [self titleColorForState:UIControlStateNormal];
}


- (void)setTitleColor:(UIColor *)color {
  [self setTitleColor:color forState:UIControlStateNormal];
}


- (UIColor*)litTitleColor {
  return [self titleColorForState:UIControlStateHighlighted];
}


- (void)setLitTitleColor:(UIColor *)color {
  [self setTitleColor:color forState:UIControlStateHighlighted];
}


- (UIColor*)disabledTitleColor {
  return [self titleColorForState:UIControlStateDisabled];
}


- (void)setDisabledTitleColor:(UIColor *)color {
  [self setTitleColor:color forState:UIControlStateDisabled];
}


- (void)addTarget:(id)target action:(SEL)action {
  [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end

