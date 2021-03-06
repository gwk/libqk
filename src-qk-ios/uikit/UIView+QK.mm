// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "qk-cr.h"
#import "UIImageView+QK.h"
#import "CRColor.h"
#import "CRView.h"


@implementation UIView (QK)


+ (instancetype)forAutolayout {
    return [[self alloc] initForAutoLayout];
}


- (instancetype)initForAutoLayout {
    INIT(self initWithFrame:CGRect256);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return self;
}


- (void)setupLayer {} // no-op for ios.


- (UIImage*)renderedImage {
  CGSize size = self.bounds.size;
  CGFloat scale = [UIScreen mainScreen].scale;
  UIGraphicsBeginImageContextWithOptions(size, NO, scale);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  // to flip y:
  //CGContextTranslateCTM(ctx, 0, size.height);
  //CGContextScaleCTM(ctx, 1, -1);
  [self.layer renderInContext:ctx];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}


- (UIImageView*)renderedImageView {
  UIImageView* v = [UIImageView withImage:[self renderedImage]];
  v.frame = self.frame;
  return v;
}


- (void)animateRenderedFromFrame:(CGRect)fromFrame
                           alpha:(CGFloat)alpha
                        duration:(CGFloat)duration
                      completion:(void (^)(BOOL finished))completionBlock {
  CGRect toFrame = self.frame;
  CGFloat toAlpha = self.alpha;
  UIImageView* v = [self renderedImageView];
  v.frame = fromFrame;
  v.alpha = alpha;
  [self.superview insertSubview:v aboveSubview:self];
  self.hidden = YES;
  [UIView animateWithDuration:duration animations:^{
    v.frame = toFrame;
    v.alpha = toAlpha;
  }
                   completion:^(BOOL completed){
                     [v removeFromSuperview];
                     self.hidden = NO;
                     if (completionBlock) {
                       completionBlock(completed);
                     }
                   }];
}


- (void)constrainViews:(NSDictionary *)views
               strings:(NSArray *)strings
               metrics:(NSDictionary *)metrics
               options:(NSLayoutFormatOptions)options {
    for (NSString* s in strings) {
        NSArray* a = nil;
        @try {
            a = [NSLayoutConstraint constraintsWithVisualFormat:s options:options metrics:metrics views:views];
            [self addConstraints:a];
        }
        @catch (NSException* exc) {
            NSLog(@"autolayout exception: %@\n  string: %@\n  constraints: %@", exc, s, a);
            @throw exc;
        }
    }
}


- (void)constrainViews:(NSDictionary *)views strings:(NSArray *)strings metrics:(NSDictionary *)metrics {
    [self constrainViews:views strings:strings metrics:metrics options:0];
}


- (void)constrainViews:(NSDictionary *)views strings:(NSArray *)strings {
    [self constrainViews:views strings:strings metrics:nil options:0];
}


@end
