// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.

#import "NSUIView.h"


@interface UIButton (QK)

@property (nonatomic) NSString* title;

+ (id)withFrame:(CGRect)frame
           flex:(UIFlex)flex
         target:(id)target
         action:(SEL)action
          title:(NSString*)title;

@end

