// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface NSMenuItem (QK)

+ (NSMenuItem*)withSubmenu:(NSMenu*)menu;
+ (NSMenuItem*)withTitle:(NSString*)title action:(SEL)action keyEquivalent:(NSString*)keyEquivalent;
+ (NSMenuItem*)quitItem;

@end

