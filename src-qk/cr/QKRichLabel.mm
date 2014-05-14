// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKTextLayer.h"
#import "QKRichLabel.h"


@interface QKRichLabel ()
@end


@implementation QKRichLabel


#pragma mark - NSObject


#pragma mark - CRView


+ (Class)layerClass {
  return [QKTextLayer class];
}


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
#if TARGET_OS_IPHONE
  self.contentScaleFactor = [[UIScreen mainScreen] scale];
  self.contentMode = UIViewContentModeRedraw;
#else
  // TODO: make the view/layer screen-aware?
  // TODO: specify redraw behavior?
#endif
  return self;
}


#pragma mark - QKLitView


- (void)setIsLit:(BOOL)isLit { // TODO: use this.
  _isLit = isLit;
}


#pragma  mark - QKRichLabel

PROPERTY_SUBCLASS_ALIAS_RO(QKTextLayer, textLayer, self.layer)

PROPERTY_ALIAS(NSAttributedString*, richText, RichText, self.textLayer.richText, [self setNeedsDisplay]; )
PROPERTY_ALIAS(QKVertAlignment, vertAlignment, VertAlignment, self.textLayer.vertAlignment, [self setNeedsDisplay]; );

@end
