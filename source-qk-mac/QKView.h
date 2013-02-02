// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "QKPixFmt.h"
#import "QKGLLayer.h"


@protocol QKCGRenderer;


@interface QKView : NSView

@property (nonatomic, weak, readonly) id renderer; // QKGLRenderer or QKCGRenderer
@property (nonatomic, readonly) QKGLLayer* glLayer;
@property (nonatomic) NSTimeInterval animationInterval;

- (id)initWithFrame:(CGRect)frame renderer:(id)renderer glFormat:(QKPixFmt)glFormat;
- (id)initWithFrame:(CGRect)frame renderer:(id)renderer;

+ (id)withFrame:(CGRect)frame renderer:(id)renderer glFormat:(QKPixFmt)glFormat;
+ (id)withFrame:(CGRect)frame renderer:(id)renderer;

@end



@protocol QKCGRenderer <NSObject>

- (void)drawInCGContext:(CGContextRef)ctx time:(NSTimeInterval)time size:(CGSize)size;

@end
