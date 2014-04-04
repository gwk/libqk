// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "CUIView.h"


@interface UIButton (QK)

@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* litTitle;
@property (nonatomic) NSAttributedString* attrTitle;
@property (nonatomic) NSAttributedString* litAttrTitle;
@property (nonatomic) UIColor* titleColor;
@property (nonatomic) UIColor* disabledTitleColor;

+ (instancetype)withFrame:(CGRect)frame
                     flex:(UIFlex)flex
                   target:(id)target
                   action:(SEL)action
                    title:(NSString*)title;

- (void)addTarget:(id)target action:(SEL)action;

@end

