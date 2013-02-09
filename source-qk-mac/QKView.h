// Copyright 2012 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "QKPixFmt.h"
#import "QKGLLayer.h"


@protocol QKCGScene;


@interface QKView : NSView

@property (nonatomic, weak) id scene; // GLScene or QKCGScene
@property (nonatomic, readonly) QKGLLayer* glLayer;
@property (nonatomic) NSTimeInterval animationInterval;

DEC_INIT(Frame:(CGRect)frame scene:(id)scene format:(QKPixFmt)format);
DEC_INIT(Frame:(CGRect)frame scene:(id)scene);

@end



@protocol QKCGScene <NSObject>

- (void)drawInCGContext:(CGContextRef)ctx time:(NSTimeInterval)time size:(CGSize)size;

@end
