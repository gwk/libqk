// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <Cocoa/Cocoa.h>

@interface NSApplication (QK)

+ (int)launchWithDelegateClass:(Class)delegateClass activationPolicy:(NSApplicationActivationPolicy)activationPolicy;

@end
