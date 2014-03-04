// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UIAlertView+QK.h"


@implementation UIAlertView (QK)


+ (UIAlertView*)showWithTitle:(NSString*)title message:(NSString*)message cancelTitle:(NSString*)cancelTitle {
    NSLog(@"alert: %@; %@;", title, message);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}

@end
