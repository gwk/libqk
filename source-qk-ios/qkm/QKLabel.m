// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QKM.h"
#import "QKBinding.h"
#import "QKLabel.h"


@interface QKLabel ()

@property (nonatomic) QKBinding* binding;

@end


@implementation QKLabel


#pragma mark - NSObject


DEF_DEALLOC_DISSOLVE {
  DISSOLVE(_binding);
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  _verticalAlign = QKVerticalAlignCenter; // imitate UILabel.
  return self;
}


#pragma mark - UILabel


- (void)setText:(NSString*)text {
  if (text) {
    self.enabled = YES;
  }
  else {
    text = _placeholder;
    self.enabled = NO;
  }
  [super setText:text];
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
  CGRect b = self.bounds;
  CGRect bp = UIEdgeInsetsInsetRect(b, _pad);
  CGRect r = [super textRectForBounds:bp limitedToNumberOfLines:numberOfLines];
  qk_assert(CGRectContainsRect(bp, r), @"textRectForBounds returned oversized rect: %@; b: %@; bp: %@",
            NSStringFromCGRect(r), NSStringFromCGRect(b), NSStringFromCGRect(bp));
  switch (_verticalAlign) {
    case QKVerticalAlignTop:
      break;
    case QKVerticalAlignCenter:
      r.origin.y = bp.origin.y + (bp.size.height - r.size.height) * .5;
      break;
    case QKVerticalAlignBottom:
      r.origin.y = bp.origin.y + (bp.size.height - r.size.height);
      break;
  }
  return r;
}


-(void)drawTextInRect:(CGRect)rect {
  CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
  [super drawTextInRect:r];
}


#pragma  mark - QKBindingLabel


- (void)setPlaceholder:(NSString*)placeholder {
  _placeholder = placeholder;
  if (!self.text) {
    self.enabled = NO;
    [super setText:placeholder];
  }
}


- (void)setVerticalAlign:(QKVerticalAlign)verticalAlign {
  _verticalAlign = verticalAlign;
  [self setNeedsDisplay];
}


- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform {
  _binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"text" transform:viewTransform];
}


@end
