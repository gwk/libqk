// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "TestMacAppDelegate.h"
#import "CRView.h"
#import "CRColor.h"
#import "QKWindow.h"
#import "TestView.h"

@interface TestMacAppDelegate ()
@end


@implementation TestMacAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  CRView* v = [TestView withFlexSize:CGSizeMake(512, 512)];
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
