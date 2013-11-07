// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSApplication+QK.h"


static NSObject<NSApplicationDelegate>* g_app_delegate; // global variable retains app delegate.

@implementation NSApplication (QK)


+ (int)launchWithDelegateClass:(Class)delegateClass {
  @autoreleasepool {
    ASSERT_WCHAR_IS_UTF32;
    
    [NSApplication sharedApplication]; // initialize the app
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular]; // necessary?
    [NSApp activateIgnoringOtherApps:NO]; // necessary?
    
    // app delegate saved to global so that object is retained for lifetime of app
    g_app_delegate = [delegateClass new];
    [NSApp setDelegate:g_app_delegate];
    
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
    
    NSMenu *menuBar = [NSMenu new];
    [menuBar addItem:appMenuBarItem];
    [NSApp setMainMenu:menuBar];
    
    [NSApp run];
  }
  return 0;
}


@end
