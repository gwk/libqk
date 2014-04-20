// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "NSApplication+QK.h"


static NSObject<NSApplicationDelegate>* appDelegate; // global variable retains app delegate.

@implementation NSApplication (QK)


+ (int)launchWithDelegateClass:(Class)delegateClass activationPolicy:(NSApplicationActivationPolicy)activationPolicy {
  @autoreleasepool {
    ASSERT_WCHAR_IS_UTF32;
    
    [self sharedApplication]; // initialize the app and set NSApp.
    [NSApp setActivationPolicy:activationPolicy];
    
    // app delegate saved to global so that object is retained for lifetime of app
    appDelegate = [delegateClass new];
    [NSApp setDelegate:appDelegate];
    
    NSProcessInfo* processInfo = [NSProcessInfo processInfo];

    // menu bar
    NSMenuItem* quitItem =
    [[NSMenuItem alloc] initWithTitle:[@"Quit " stringByAppendingString:processInfo.processName]
                               action:@selector(terminate:)
                        keyEquivalent:@"q"];
    
    NSMenu* appMenu = [NSMenu new];
    [appMenu addItem:quitItem];
    
    NSMenuItem *appMenuBarItem = [NSMenuItem new];
    [appMenuBarItem setSubmenu:appMenu];
    
    NSMenu* menuBar = [NSMenu new];
    [menuBar addItem:appMenuBarItem];
    [NSApp setMainMenu:menuBar];
    
    [NSApp run];
  }
  return 0;
}


@end
