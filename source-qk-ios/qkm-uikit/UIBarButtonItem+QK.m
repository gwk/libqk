// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIBarButtonItem+QK.h"


@implementation UIBarButtonItem (QK)


+ (id)withTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
  return [[self alloc] initWithTitle:title style:style target:target action:action];
}


+ (id)withTitle:(NSString *)title target:(id)target action:(SEL)action {
  return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}


@end

