// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "CUIColor.h"


#if TARGET_OS_IPHONE
#import "UIView+QK.h"
# define CUIView UIView
typedef UILayoutConstraintAxis UIAxis;

#else
#import "NSView+QK.h"
# define CUIView NSView
typedef NSUInteger UIViewAutoresizing;
typedef NSLayoutConstraintOrientation UIAxis;
typedef NSLayoutPriority UILayoutPriority; // this is dirty, but good enough for now.

#endif

typedef UIViewAutoresizing UIFlex;

extern const UIFlex UIFlexN;
extern const UIFlex UIFlexW;
extern const UIFlex UIFlexH;
extern const UIFlex UIFlexL;
extern const UIFlex UIFlexR;
extern const UIFlex UIFlexT;
extern const UIFlex UIFlexB;

extern const UIFlex UIFlexSize;
extern const UIFlex UIFlexHori;
extern const UIFlex UIFlexVert;
extern const UIFlex UIFlexPos;

extern const UIFlex UIFlexWL;
extern const UIFlex UIFlexWR;

extern const UIAxis UIAxisH;
extern const UIAxis UIAxisV;

extern CGContextRef CUICurrentCtx();

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
@property(nonatomic) CGFloat bcx;
@property(nonatomic) CGFloat bcy;
@property(nonatomic) CGPoint bo;
@property(nonatomic) CGSize bs;
@property(nonatomic) UILayoutPriority huggingH;
@property(nonatomic) UILayoutPriority huggingV;
@property(nonatomic) UILayoutPriority compressionH;
@property(nonatomic) UILayoutPriority compressionV;

DEC_WITH(Frame:(CGRect)frame);
DEC_INIT(Frame:(CGRect)frame flex:(UIFlex)flex);
DEC_INIT(FlexFrame:(CGRect)frame);
DEC_INIT(FlexFrame);
DEC_INIT(Size:(CGSize)size);
DEC_INIT(FlexSize:(CGSize)size);
DEC_INIT(Size:(CGSize)size flex:(UIFlex)flex);

DEC_WITH(Frame:(CGRect)frame flex:(UIFlex)flex  color:(CUIColor*)color);

- (void)removeAllSubviews;
- (void)insertSubview:(CUIView*)subview comparator:(NSComparator)comparator;

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

