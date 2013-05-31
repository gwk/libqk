// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "CUIView.h"


@interface UIView (QK)

@property (nonatomic) UIViewAutoresizing flex;
@property (nonatomic) CGPoint boundsOrigin;
@property (nonatomic) CGSize boundsSize;

+ (id)withFrame:(CGRect)frame flex:(UIFlex)flex  color:(UIColor*)color;

- (UIImage*)renderImage;

@end
