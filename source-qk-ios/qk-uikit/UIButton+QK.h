// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIButton (QK)

@property (nonatomic) NSString* title;

+ (id)withFrame:(CGRect)frame
           flex:(UIViewAutoresizing)flex
         target:(id)target
         action:(SEL)action
          title:(NSString*)title;

@end

