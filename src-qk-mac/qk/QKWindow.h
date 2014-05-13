// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "CRView.h"


typedef enum {
  QKWindowScreenModeNone = 0,
  QKWindowScreenModeCover, // cover a single screen
  QKWindowScreenModeFull, // use OS X full-screen mode, which disables other screens.
} QKWindowScreenMode;


@protocol QKWindowDelegate;


@interface QKWindow : NSWindow

@property (nonatomic) CRView* view;
@property (nonatomic) id<QKWindowDelegate> delegate;
@property (nonatomic, readonly) QKWindowScreenMode screenMode;
@property (nonatomic) BOOL coversScreen;
@property (nonatomic) CGPoint position; // top-down coordinate for visible screen rect.

DEC_INIT(View:(CRView *)view
         delegate:(id<QKWindowDelegate>)delegate
         styleMask:(NSUInteger)styleMask
         screenMode:(QKWindowScreenMode)screenMode
         position:(CGPoint)position
         activate:(BOOL)activate);

DEC_INIT(View:(CRView*)view
         delegate:(id<QKWindowDelegate>)delegate
         closeable:(BOOL)closeable
         miniaturizable:(BOOL)miniaturizable
         resizable:(BOOL)resizable
         screenMode:(QKWindowScreenMode)screenMode
         position:(CGPoint)position
         activate:(BOOL)activate);

- (NSView*)view;

- (void)toggleCoversScreen;
- (void)setContentSizeAndAspect:(CGSize)size;

@end


@protocol QKWindowDelegate <NSWindowDelegate>
@optional

- (void)windowChangedCoversScreen:(QKWindow*)window;
- (void)windowChangedScreen:(QKWindow*)window;

@end
