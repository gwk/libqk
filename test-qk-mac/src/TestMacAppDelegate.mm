// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "TestMacAppDelegate.h"
#import "CUIView.h"
#import "CUIColor.h"
#import "QKWindow.h"
#import "TestView.h"

@interface TestMacAppDelegate ()
@end


@implementation TestMacAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  CUIView* v = [TestView withFlexSize:CGSizeMake(512, 512)];
  _window = [QKWindow withView:v
                      delegate:nil
                     closeable:NO
                miniaturizable:YES
                     resizable:YES
                    screenMode:QKWindowScreenModeCover
                      position:CGPointMake(256, 256)
                      activate:YES];
}

@end
