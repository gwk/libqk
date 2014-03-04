// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface UIBarButtonItem (QK)

+ (instancetype)withTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (instancetype)withTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)withSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;

@end

