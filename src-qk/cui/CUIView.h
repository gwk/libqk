// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "CUIColor.h"


#if TARGET_OS_IPHONE
#import "UIView+QK.h"
# define CUIView UIView
#else
#import "NSView+QK.h"
# define CUIView NSView
typedef NSUInteger UIViewAutoresizing;
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
extern const UIFlex UIFlexPosition;

extern const UIFlex UIFlexWidthLeft;
extern const UIFlex UIFlexWidthRight;


@interface CUIView (CUI)

@property(nonatomic) UIFlex flex;
@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;
@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGPoint boundsCenter;
@property(nonatomic) CGPoint boundsOrigin;
@property(nonatomic) CGSize boundsSize;


DEC_WITH(Frame:(CGRect)frame);
DEC_INIT(Frame:(CGRect)frame flex:(UIFlex)flex);
DEC_INIT(FlexFrame:(CGRect)frame);
DEC_INIT(FlexFrame);
DEC_INIT(Size:(CGSize)size);
DEC_INIT(FlexSize:(CGSize)size);

DEC_WITH(Frame:(CGRect)frame flex:(UIFlex)flex  color:(CUIColor*)color);

- (void)removeAllSubviews;

// debugging

- (NSString*)descFrame;
- (NSString*)descBounds;
- (NSString*)descCenter;
- (NSString*)descFlex;

- (void)inspect;
- (void)inspect:(NSString*)label;
- (void)inspectParents;
- (void)inspectParents:(NSString*)label;

@end

