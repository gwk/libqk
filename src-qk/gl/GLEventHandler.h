// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-vec.h"

@class GLView;

@interface GLEventHandler : NSObject

#if TARGET_OS_IPHONE
- (BOOL)touchesBegan:(UIEvent*)event view:(GLView*)view;
- (BOOL)touchesMoved:(UIEvent*)event view:(GLView*)view;
- (BOOL)touchesEnded:(UIEvent*)event view:(GLView*)view;
- (BOOL)touchesCancelled:(UIEvent*)event view:(GLView*)view;
#endif

@end


@protocol GLSceneScroll2 <NSObject>

- (void)adjustTranslation:(V2)delta layerSize:(V2)layerSize;
- (void)adjustScale:(F32)factor around:(V2)point layerSize:(V2)layerSize;
- (void)adjustRotation:(F32)delta;

@end
