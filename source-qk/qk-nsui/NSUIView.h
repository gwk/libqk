// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"


#if TARGET_OS_IPHONE
# define NSUIView UIView
#else
# define NSUIView NSView
typedef Int UIFlex;
#endif

typedef UIViewAutoresizing UIFlex;

extern const UIFlex UIFlexNone;
extern const UIFlex UIFlexWidth;
extern const UIFlex UIFlexHeight;
extern const UIFlex UIFlexLeft;
extern const UIFlex UIFlexRight;
extern const UIFlex UIFlexTop;
extern const UIFlex UIFlexBottom;

extern const UIFlex UIFlexSize;
extern const UIFlex UIFlexHorizontal;
extern const UIFlex UIFlexVertical;


@interface NSUIView (NSUI)


@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGPoint boundsCenter;


DEC_WITH(Frame:(CGRect)frame);
DEC_INIT(Frame:(CGRect)frame flex:(UIFlex)flex);
DEC_INIT(FlexFrame:(CGRect)frame);
DEC_INIT(FlexFrame);

- (void)inspect:(NSString*)label;
- (void)inspectParents:(NSString*)label;


@end

