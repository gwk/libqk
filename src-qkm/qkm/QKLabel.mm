// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSString+QKM.h"
#import "CUIColor.h"
#import "QKBinding.h"
#import "QKLabel.h"


@interface QKLabel ()

@property (nonatomic) QKBinding* binding;

@end


@implementation QKLabel


#pragma mark - NSObject


+ (void)initialize {
  [QKLabel setDefaultColor:[UIColor l:1]];
  [QKLabel setDefaultLitColor:[UIColor r:0 g:.5 b:1]];
  [QKLabel setDefaultTextColor:[UIColor l:.1]];
  [QKLabel setDefaultLitTextColor:[UIColor l:0]];
  [QKLabel setDefaultPlaceholderColor:[UIColor l:.5]];
}


DEF_DEALLOC_DISSOLVE {
  DISSOLVE(_binding);
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  self.color = defaultColor;
  self.litColor = defaultLitColor;
  self.textColor = defaultTextColor;
  self.litTextColor = defaultLitTextColor;
  self.placeholderColor = defaultPlaceholderColor;
  _pad = UIEdgeInsetsMake(8, 8, 8, 8); // default pad matches the hard-coded pad of UITextView.
  _verticalAlign = QKVerticalAlignCenter; // matches UILabel; also fastest to calculate.
  return self;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
  self.color = backgroundColor; // calls super setBackgroundColor if !isLit
}


- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [super setBackgroundColor:(highlighted ? self.litColor : self.color)];
}


- (CGSize)sizeThatFits:(CGSize)size { // size is current bounds size
  if (_widthMax > 0) {
    size.width = [self widthThatFits];
  }
  else {
    size.height = [self heightThatFits];
  }
  return size;
}


#pragma mark - UILabel


+ (id)withFont:(UIFont*)font x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h min:(int)lineMin max:(int)lineMax flex:(UIFlex)flex {
  qk_assert(lineMin >= 0 && lineMax > 0 && lineMin <= lineMax, @"invalid line min/max: %d, %d", lineMin, lineMax);
  if (h <= 0) {
    h = font.lineHeight * lineMax + 16; // add vertical pad.
  }
  QKLabel* l = [self withFrame:CGRectMake(x, y, w, h) flex:flex];
  l.font = font;
  l.lineMin = lineMin;
  l.lineMax = lineMax;
  return l;
}


+ (id)withFontSize:(CGFloat)fontSize x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h min:(int)lineMin max:(int)lineMax flex:(UIFlex)flex {
  return [self withFont:[UIFont systemFontOfSize:fontSize] x:x y:y w:w h:h min:lineMin max:lineMax flex:flex];
}


+ (id)withFontBoldSize:(CGFloat)fontSize x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h min:(int)lineMin max:(int)lineMax flex:(UIFlex)flex {
  return [self withFont:[UIFont boldSystemFontOfSize:fontSize] x:x y:y w:w h:h min:lineMin max:lineMax flex:flex];
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
  CGRect bp = UIEdgeInsetsInsetRect(bounds, _pad);
  if (_verticalAlign == QKVerticalAlignCenter) {
    return bp;
  }
  NSString* text = LIVE_ELSE(self.text, _placeholder);
  CGRect r = bp;
  r.size.height = [text heightForFont:self.font w:bp.size.width h:bp.size.height lineBreak:self.lineBreakMode lineMin:self.lineMin];
  if (_verticalAlign == QKVerticalAlignBottom) {
      r.origin.y = floorf(bp.origin.y + (bp.size.height - r.size.height));
  }
  return r;
}


-(void)drawTextInRect:(CGRect)rect {
  CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
  // note: not tested with shadows
  if (!self.text && _placeholder) {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, _placeholderColor.CGColor);
    [_placeholder drawInRect:r withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
  }
  else {
    [super drawTextInRect:r];
  }
}


#pragma mark - QKLitView


PROPERTY_ALIAS(BOOL, isLit, IsLit, self.highlighted);


#pragma  mark - QKLabel


DEF_DEFAULT(UIColor*, Color);
DEF_DEFAULT(UIColor*, LitColor);
DEF_DEFAULT(UIColor*, TextColor);
DEF_DEFAULT(UIColor*, LitTextColor);
DEF_DEFAULT(UIColor*, PlaceholderColor);


PROPERTY_ALIAS(int, lineMax, LineMax, self.numberOfLines);

PROPERTY_STRUCT_FIELD(CGFloat, padT, PadT, UIEdgeInsets, self.pad, top);
PROPERTY_STRUCT_FIELD(CGFloat, padL, PadL, UIEdgeInsets, self.pad, left);
PROPERTY_STRUCT_FIELD(CGFloat, padB, PadB, UIEdgeInsets, self.pad, bottom);
PROPERTY_STRUCT_FIELD(CGFloat, padR, PadR, UIEdgeInsets, self.pad, right);


+ (void)setDefaultPlaceHolderColor:(UIColor*)color {
  defaultPlaceholderColor = color;
}


- (void)setColor:(UIColor *)color {
  _color = color;
  if (!_isLit) {
    [super setBackgroundColor:color];
  }
}


- (void)setLitColor:(UIColor *)litColor {
  _litColor = litColor;
  if (_isLit) {
    [super setBackgroundColor:litColor];
  }
}


PROPERTY_ALIAS(UIColor*, litTextColor, LitTextColor, self.highlightedTextColor);


- (void)setVerticalAlign:(QKVerticalAlign)verticalAlign {
  _verticalAlign = verticalAlign;
  [self setNeedsDisplay];
}


- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform {
  _binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"text" transform:viewTransform];
}


- (CGFloat)widthThatFits {
  return self.text.length
  ? [self.text widthForFont:self.font w:_widthMax lineBreak:self.lineBreakMode] + self.padL + self.padR
  : 0; // collapse pad to zero
}


- (void)fitWidth {
  qk_assert(_widthMax > 0, @"fitWidth requires positive widthMax: %@", self);
  self.width = [self widthThatFits];
}


- (CGFloat)heightThatFits {
  qk_assert(self.lineMax > 0, @"fitHeight requires positive lineMax: %@", self);
  if (self.text.length || _lineMin > 0) {
    CGFloat maxTextHeight = self.numberOfLines * self.font.lineHeight;
    CGFloat textHeight = [self.text heightForFont:self.font w:self.width h:maxTextHeight lineBreak:self.lineBreakMode lineMin:_lineMin];
    return textHeight + self.padT + self.padB;
  }
  else { // collapse pad to zero
    return 0;
  }
}


- (void)fitHeight {
  self.height = [self heightThatFits];
}


@end
