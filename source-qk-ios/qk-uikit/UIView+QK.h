// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <UIKit/UIKit.h>


extern const UIViewAutoresizing UIFlexNone;
extern const UIViewAutoresizing UIFlexWidth;
extern const UIViewAutoresizing UIFlexHeight;
extern const UIViewAutoresizing UIFlexLeft;
extern const UIViewAutoresizing UIFlexRight;
extern const UIViewAutoresizing UIFlexTop;
extern const UIViewAutoresizing UIFlexBottom;

extern const UIViewAutoresizing UIFlexSize;
extern const UIViewAutoresizing UIFlexHorizontal;
extern const UIViewAutoresizing UIFlexVertical;


@interface UIView (QK)

+ (id)withFrame:(CGRect)frame;
+ (id)withFlexFrame:(CGRect)frame;
+ (id)withFlexFrame;

@end
