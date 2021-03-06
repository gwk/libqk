// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "UIBarButtonItem+QK.h"


@implementation UIBarButtonItem (QK)


+ (instancetype)withTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
  return [[self alloc] initWithTitle:title style:style target:target action:action];
}


+ (instancetype)withTitle:(NSString *)title target:(id)target action:(SEL)action {
  return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}


+ (instancetype)withSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action {
  return [[self alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
}


@end

