// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import <CoreText/CoreText.h>
#import "NSAttributedString+QK.h"
#import "QKTextLayer.h"


@interface QKTextLayer ()

@property (nonatomic) CTFramesetterRef framesetter;

@end


@implementation QKTextLayer


#pragma mark - NSObject


- (void)dealloc {
  self.framesetter = NULL;
}


- (id)init {
  INIT(super init);
  self.contentsGravity = kCAGravityCenter;
  self.vertAlignment = QKVertAlignmentCenter; // matches UILabel.
  return self;
}


#pragma mark - CALayer


- (id)initWithLayer:(QKTextLayer*)layer {
  INIT(super initWithLayer:layer);
  _richText = layer.richText;
  return self;
}


- (void)drawInContext:(CGContextRef)ctx {
  if (!_richText) return;
  if (!_framesetter) {
    self.framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_richText);
  }
  CGContextSaveGState(ctx);
  
  // TODO: create better text rectangle.
  CGRect textRect = self.bounds;
  CFRange textRange = CFRangeMake(0, _richText.length);
  CFRange fittedRange = CFRangeMake(0, 0);
  // for now we have no frame attributes.
  CGSize fittedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, textRange, NULL, textRect.size, &fittedRange);

  // calculate vertical alignment spacing.
  CGFloat vertSpace = 0;
  if (_vertAlignment != QKVertAlignmentTop) {
    vertSpace = MAX(0, (textRect.size.height - fittedSize.height));
    if (self.vertAlignment == QKVertAlignmentCenter) {
      vertSpace *= 0.5;
    }
    vertSpace = floorf(vertSpace);
  }
  
  // invert y to use UIKit top-down system.
  auto textMatrix = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, -1), 0.0, -ceilf(self.bounds.size.height));
  CGContextSetTextMatrix(ctx, textMatrix);
  
  // create the core text frame.
  auto path = CGPathCreateMutable();
  qk_assert(path, @"nil path");
  CGPathAddRect(path, NULL, textRect);
  
  auto frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
  qk_assert(frame, @"nil frame");
  CFRelease(path);
  
  auto lines = (__bridge NSArray*)CTFrameGetLines(frame); // lines are returned in logical order.
  
  // get line origins; core text coordinate system makes the first line have the highest y value.
  // since we have already inverted the text matrix, we need to invert these values as well.
  // final coordinates stored in lineOrigins.
  Int lineCount = lines.count;
  auto lineTextOrigins  = (CGPoint*)malloc(sizeof(CGPoint) * lineCount);
  auto lineOrigins = (CGPoint*)malloc(sizeof(CGPoint) * lineCount);
  CTFrameGetLineOrigins(frame, CFRangeMake(0, lineCount), lineTextOrigins);
  
  // calculate line origins.
  // we do this as a separate pass because in the future we might like to process each text run with a callback,
  // for example to draw highlighting under specifc words.
  for_in(lineIndex, lineCount) {
    auto line = (__bridge CTLineRef)lines[lineIndex];
    // ellipsize the last line if necessary.
    if (lineIndex == lineCount - 1) {
      CFRange lineRange = CTLineGetStringRange(line);
      if (lineRange.location + lineRange.length < _richText.length) { // ellipsis is necessary.
        // use the attributes of the last character in the line.
        auto attrs = [_richText attributesAtIndex:(lineRange.location + lineRange.length - 1) effectiveRange:NULL];
        auto ellipsis = [NSAttributedString withString:@"\u2026" attrs:attrs];
        auto truncSuffix = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)ellipsis);
        // in order for truncation to produce the desired effect, we need a line that is actually too long.
        NSRange longRange = NSMakeRange(lineRange.location, lineRange.length + 1);
        auto longText = [_richText attributedSubstringFromRange:longRange];
        auto longLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)longText);
        auto truncLine = CTLineCreateTruncatedLine(longLine, textRect.size.width, kCTLineTruncationEnd, truncSuffix);
        if (truncLine) { // skip if truncation fails.
          NSMutableArray *a = lines.mutableCopy;
          a[lineIndex] = (__bridge_transfer id)truncLine; // truncLine is now borrowed, just like line was.
          lines = a;
          line = truncLine;
        }
      }
    }
    
    CGPoint lineOrigin = lineTextOrigins[lineIndex];
    // offset the lineOrigin by the textRect origin.
    lineOrigin.x += textRect.origin.x;
    // invert y to get UIKit coords and add vertical space; origin still points to the baseline of each line.
    lineOrigin.y = (textRect.origin.y + textRect.size.height - lineOrigin.y) + vertSpace;
    lineOrigins[lineIndex] = lineOrigin;
  }
  // draw lines.
  for_in (lineIndex, lineCount) {
    auto line = (__bridge CTLineRef)lines[lineIndex];
    CGPoint lineOrigin = lineOrigins[lineIndex];
    CGContextSetTextPosition(ctx, lineOrigin.x, lineOrigin.y);
    CTLineDraw(line, ctx);
  }
  free(lineTextOrigins);
  free(lineOrigins);
  CFRelease(frame);
  CGContextRestoreGState(ctx);
}


DEF_SET_CF_RETAIN(CTFramesetterRef, framesetter, Framesetter);


- (void)setRichText:(NSAttributedString*)richText {
  _richText = richText;
  self.framesetter = NULL;
  [self setNeedsDisplay];
}


@end

