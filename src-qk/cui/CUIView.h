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
@property(nonatomic) CGPoint o;
@property(nonatomic) CGSize s;
@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat w;
@property(nonatomic) CGFloat h;
@property(nonatomic) CGPoint c;
@property(nonatomic) CGFloat cx;
@property(nonatomic) CGFloat cy;
@property(nonatomic) CGFloat r;
@property(nonatomic) CGFloat b;
@property(nonatomic) CGPoint bc;
@property(nonatomic) CGPoint bo;
@property(nonatomic) CGSize bs;


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

