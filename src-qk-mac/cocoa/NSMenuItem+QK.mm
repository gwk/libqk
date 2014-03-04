// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "NSMenuItem+QK.h"


@implementation NSMenuItem (QK)


+ (NSMenuItem*)withSubmenu:(NSMenu*)menu {
  NSMenuItem* item = [self new];
  [item setSubmenu:menu];
  return item;
}


+ (NSMenuItem*)withTitle:(NSString*)title action:(SEL)action keyEquivalent:(NSString*)keyEquivalent {
  return [[self alloc] initWithTitle:title action:action keyEquivalent:keyEquivalent];
}


+ (NSMenuItem*)quitItem {
  return [self withTitle:[@"Quit " stringByAppendingString:[[NSProcessInfo processInfo] processName]]
                  action:@selector(terminate:)
           keyEquivalent:@"q"];
}


@end

