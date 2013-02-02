// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKView.h"


typedef enum {
  QKWindowScreenModeNone = 0,
  QKWindowScreenModeCover, // cover a single screen
  QKWindowScreenModeFull, // use OS X full-screen mode, which disables other screens.
} QKWindowScreenMode;


@protocol QKWindowDelegate;


@interface QKWindow : NSWindow

@property (nonatomic) id<QKWindowDelegate> delegate;
@property (nonatomic, readonly) QKWindowScreenMode screenMode;
@property (nonatomic) BOOL coversScreen;

- (id)initWithView:(NSView *)view
         styleMask:(NSUInteger)styleMask
        screenMode:(QKWindowScreenMode)screenMode
          position:(CGPoint)position
          activate:(BOOL)activate;

+ (id)withView:(NSView*)view
     styleMask:(NSUInteger)styleMask
    screenMode:(QKWindowScreenMode)screenMode
      position:(CGPoint)position
      activate:(BOOL)activate;

+ (id)withView:(NSView*)view
     closeable:(BOOL)closeable
miniaturizable:(BOOL)miniaturizable
     resizable:(BOOL)resizable
    screenMode:(BOOL)screenMode
      position:(CGPoint)position
      activate:(BOOL)activate;

- (QKView*)qkView;

- (void)setOriginFromVisibleTopLeft:(CGPoint)origin;

- (void)toggleCoversScreen;

@end


@protocol QKWindowDelegate <NSWindowDelegate>

@optional
- (void)windowCovered:(QKWindow*)window;

@end
