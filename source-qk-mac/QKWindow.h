// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKView.h"


@protocol QKWindowDelegate;


@interface QKWindow : NSWindow

@property (nonatomic) id<QKWindowDelegate> delegate;
@property (nonatomic) BOOL coversScreen;

- (id)initWithView:(NSView *)view styleMask:(NSUInteger)styleMask;
- (id)initWithView:(NSView *)view;

- (QKView*)qkView;

- (void)setOriginFromVisibleTopLeft:(CGPoint)origin;

- (void)toggleCoversScreen;

@end


@protocol QKWindowDelegate <NSWindowDelegate>

@optional
- (void)windowCovered:(QKWindow*)window;

@end
