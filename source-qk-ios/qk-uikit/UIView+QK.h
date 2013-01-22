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

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint boundsOrigin;
@property (nonatomic) CGSize boundsSize;
@property (nonatomic) CGPoint boundsCenter;


- (id)initWithFrame:(CGRect)frame flex:(UIViewAutoresizing)flex;
- (id)initWithFlexFrame:(CGRect)frame;
- (id)initWithFlexFrame;

+ (id)withFrame:(CGRect)frame;
+ (id)withFrame:(CGRect)frame flex:(UIViewAutoresizing)flex;
+ (id)withFlexFrame:(CGRect)frame;
+ (id)withFlexFrame;

@end
