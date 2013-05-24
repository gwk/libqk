// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSString+QKM.h"
#import "UIColor+QK.h"
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
  _verticalAlign = QKVerticalAlignCenter; // imitate UILabel.
  _pad = UIEdgeInsetsMake(8, 8, 8, 8); // default pad matches the hard-coded pad of UITextView. 
  return self;
}


// set both for consistency; this would only be called by code unaware of qk. one or the other calls super, depending on isLit.
- (void)setBackgroundColor:(UIColor *)backgroundColor {
  self.color = backgroundColor;
  self.litColor = backgroundColor;
}


- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [super setBackgroundColor:(highlighted ? self.litColor : self.color)];
}


#pragma mark - UILabel


// NOTE: this implementation should be kept in sync with that of UILabel.
+ (id)withFont:(UIFont*)font lines:(int)lines x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h flex:(UIFlex)flex {
  if (h <= 0) {
    qk_assert(lines > 0, @"lines and height are both zero");
    h = font.lineHeight * lines + 16; // like UILabel, but add the default pad.
  }
  UILabel* l = [self withFrame:CGRectMake(x, y, w, h) flex:flex];
  l.font = font;
  l.numberOfLines = lines;
  return l;
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
  CGRect bp = UIEdgeInsetsInsetRect(bounds, _pad);
  NSString* text = LIVE_ELSE(self.text, _placeholder);
  CGRect r = bp;
  r.size.height = [text heightForFont:self.font w:bp.size.width h:bp.size.height lineBreak:self.lineBreakMode lineMin:numberOfLines];
  switch (_verticalAlign) {
    case QKVerticalAlignTop:
      break;
    case QKVerticalAlignCenter:
      r.origin.y = floorf(bp.origin.y + (bp.size.height - r.size.height) * .5);
      break;
    case QKVerticalAlignBottom:
      r.origin.y = floorf(bp.origin.y + (bp.size.height - r.size.height));
      break;
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


@end
