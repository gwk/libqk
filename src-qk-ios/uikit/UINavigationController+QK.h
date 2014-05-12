// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


@interface UINavigationController (QK)

+ (instancetype)withRoot:(UIViewController*)rootController;

- (void)push:(UIViewController*)controller;
- (void)replaceTopWith:(UIViewController*)controller;

@end

