// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSMenuItem+QK.h"
#import "NSMenu+QK.h"


@implementation NSMenu (QK)


+ (NSMenu*)withTitle:(NSString*)title items:(NSArray*)items {
  NSMenu* m = [[self alloc] initWithTitle:title];
  for (NSMenuItem* item in items) {
    [m addItem:item];
  }
  return m;
}


+ (NSMenu*)withSubmenus:(NSArray*)submenus {
  NSMenu* m = [self new];
  for (NSMenu* submenu in submenus) {
    ASSERT_KIND(submenu, NSMenu);
    [m addItem:[NSMenuItem withSubmenu:submenu]];
  }
  return m;
}


@end

