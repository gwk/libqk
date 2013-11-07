// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIBarButtonItem (QK)

+ (id)withTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id)withTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (id)withSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;

@end

