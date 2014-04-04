// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface UIImage (QK)

+ (UIImage*)withColor:(UIColor *)color size:(CGSize)size;
+ (UIImage*)withColor:(UIColor*)color;
+ (UIImage*)named:(NSString*)name;

- (UIImage*)lumImageOpaque;

@end
