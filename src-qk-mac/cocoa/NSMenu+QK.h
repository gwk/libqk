// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface NSMenu (QK)

+ (NSMenu*)withTitle:(NSString*)title items:(NSArray*)items;
+ (NSMenu*)withSubmenus:(NSArray*)submenus;

@end

