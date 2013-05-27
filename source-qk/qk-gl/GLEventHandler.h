// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-vec.h"

@class GLView;

@interface GLEventHandler : NSObject

@property (nonatomic) V2F32 position;
@property (nonatomic) F32 scale;
@property (nonatomic) F32 rotation;

- (BOOL)touchesBegan:(UIEvent*)event view:(GLView*)view;
- (BOOL)touchesMoved:(UIEvent*)event view:(GLView*)view;
- (BOOL)touchesEnded:(UIEvent*)event view:(GLView*)view;
- (BOOL)touchesCancelled:(UIEvent*)event view:(GLView*)view;

@end


