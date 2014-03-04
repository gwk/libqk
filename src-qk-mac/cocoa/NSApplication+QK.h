// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <Cocoa/Cocoa.h>

#define LAUNCH_APP(appClass, delegateClass) [appClass launchWithDelegateClass:[delegateClass class]]

@interface NSApplication (QK)

+ (int)launchWithDelegateClass:(Class)delegateClass;

@end
