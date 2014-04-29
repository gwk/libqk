// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSApplication+QK.h"
#import "TestMacAppDelegate.h"


int main(int argc, char *argv[]) {
  return [NSApplication launchWithDelegateClass:[TestMacAppDelegate class] activationPolicy:NSApplicationActivationPolicyRegular];
}
