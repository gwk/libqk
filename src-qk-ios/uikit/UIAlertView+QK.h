// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


@interface UIAlertView (QK)

+ (UIAlertView*)showWithTitle:(NSString*)title message:(NSString*)message cancelTitle:(NSString*)cancelTitle;
+ (UIAlertView*)showWithError:(NSError*)error;

@end
