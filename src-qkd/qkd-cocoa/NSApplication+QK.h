// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Cocoa/Cocoa.h>

#define LAUNCH_APP(app_class, delegate_class) [app_class launchWithDelegateClass:[delegate_class class]]

@interface NSApplication (QK)

+ (int)launchWithDelegateClass:(Class)delegateClass;

@end
