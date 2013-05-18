// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIView (QK)

@property (nonatomic) CGPoint boundsOrigin;
@property (nonatomic) CGSize boundsSize;

+ (id)withFrame:(CGRect)frame flex:(UIFlex)flex  color:(UIColor*)color;

@end
