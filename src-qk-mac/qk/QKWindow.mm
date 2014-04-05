// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "qk-log.h"
#import "NSString+QK.h"
#import "CUIView.h"
#import "QKWindowView.h"
#import "QKWindow.h"


@interface QKWindow ()

@property (nonatomic) CGRect normalFrame;
@property (nonatomic) CGSize normalAspect;
@property (nonatomic) NSUInteger normalStyleMask;
@property (nonatomic) NSInteger normalLevel;
@property (nonatomic) BOOL normalOpaque;
@property (nonatomic) BOOL normalHidesOnDeactivate;
@property (nonatomic) NSButton* screenButton;
@property (nonatomic) NSTimer* timer;

@end


@implementation QKWindow

@dynamic delegate; // redeclaration of super property.


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSString*)description {
  return fmt(@"<%@ %p: %@>", self.class, self, NSStringFromCGRect(self.frame));
}


DEF_INIT(View:(CUIView *)view
         delegate:(id<QKWindowDelegate>)delegate
         styleMask:(NSUInteger)styleMask
         screenMode:(QKWindowScreenMode)screenMode
         position:(CGPoint)position
         activate:(BOOL)activate) {
  
  if (view.w < 1 || view.h < 1) {
    errFL(@"WARNING: view is degenerate: %@", view);
  }
  INIT(super initWithContentRect:view.frame styleMask:styleMask backing:NSBackingStoreBuffered defer:YES);
  
  _screenMode = screenMode;
  self.contentView = [QKWindowView withFlexFrame:_view.bounds];
  self.view = view;
  self.delegate = delegate;
  self.backgroundColor = [NSColor blueColor]; // for debugging blank windows
  self.releasedWhenClosed = NO;
  self.position = position;
  self.minSize = CGSizeMake(96, 0); // this needs to be enforced elsewhere, probably due to aspect ratio. 
  if (_screenMode == QKWindowScreenModeCover) {
    [self addScreenButton];
  }
  else if (_screenMode == QKWindowScreenModeFull) {
    self.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
  }
  
  if (activate) {
    [self makeKeyAndOrderFront:nil];
    [self makeMainWindow]; // must come after makeKeyAndOrderFront
  }
  else {
    [self orderBack:nil];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(screenDidChange:)
                                               name:NSWindowDidChangeScreenNotification
                                             object:self];
  
  [self screenDidChange:nil]; // retina resolution factor is not recognized on first frame, so this is necessary.
  return self;
}


DEF_INIT(View:(CUIView*)view
         delegate:(id<QKWindowDelegate>)delegate
         closeable:(BOOL)closeable
         miniaturizable:(BOOL)miniaturizable
         resizable:(BOOL)resizable
         screenMode:(QKWindowScreenMode)screenMode
         position:(CGPoint)position
         activate:(BOOL)activate) {
  
  NSUInteger styleMask =
  NSTitledWindowMask
  | (closeable ? NSClosableWindowMask : 0)
  | (miniaturizable ? NSMiniaturizableWindowMask : 0)
  | (resizable ? NSResizableWindowMask : 0);
  return [self initWithView:view
                   delegate:delegate
                  styleMask:styleMask
                 screenMode:screenMode
                   position:position
                   activate:activate];
}



- (void)setFrame:(CGRect)frame {
  [self setFrame:frame display:YES];
}


- (CGPoint)position {
  CGRect svf = self.screen.visibleFrame;
  CGFloat vsh = svf.origin.y + svf.size.height; // visible screen height accounts for possible menu bar
  CGRect f = self.frame;
  return CGPointMake(f.origin.x, vsh - (f.origin.y + f.size.height));
}


- (void)setPosition:(CGPoint)position {
  CGRect svf = self.screen.visibleFrame;
  CGFloat vsh = svf.origin.y + svf.size.height; // visible screen height accounts for possible menu bar
  CGRect f = self.frame;
  f.origin = CGPointMake(position.x, vsh - (position.y + f.size.height));
  self.frame = f;
  [self constrainFrameRect:f toScreen:self.screen];
}


- (void)setView:(CUIView *)view {
  [_view removeFromSuperview];
  _view = view;
  [self.contentView addSubview:_view];
}


// since the title bar gets removed on cover screen, we must add the button on init and every time we uncover.
- (void)addScreenButton {
  qk_assert(_screenMode == QKWindowScreenModeCover, @"addScreenButton only works with cover mode");
  NSView* windowView = [self.contentView superview];
  if (!_screenButton) { // setup cover screen button
    CGRect wf = windowView.frame;
    NSImage* image = [NSImage imageNamed:NSImageNameEnterFullScreenTemplate];
    CGSize s = image.size;
    CGRect frame = CGRectMake(wf.size.width - s.width - 3, wf.size.height - s.height - 3, s.width, s.height);
    _screenButton =  [[NSButton alloc] initWithFrame:frame];
    _screenButton.target = self;
    _screenButton.action = @selector(toggleCoversScreen);
    _screenButton.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    _screenButton.image = image;
    _screenButton.bordered = NO;
    // TODO: fix white in highlight state.
  }
  [windowView addSubview:_screenButton];
}


- (void)setCoversScreen:(BOOL)coversScreen {
  if (_coversScreen == coversScreen) return;
  
  _coversScreen = coversScreen;
  
  if (coversScreen) {
    self.normalFrame = self.frame;
    self.normalStyleMask = self.styleMask;
    self.normalLevel = self.level;
    self.normalOpaque = self.isOpaque;
    self.normalHidesOnDeactivate = self.hidesOnDeactivate;
    
    self.styleMask = NSBorderlessWindowMask; // set mask before changing frame
    self.frame = self.screen.frame;
    self.level = NSMainMenuWindowLevel + 1; // set the window to sit above the menu bar
    self.opaque = YES;
    self.hidesOnDeactivate = YES;
    
    [self makeKeyAndOrderFront:nil];
  }
  else { // return to normal
    self.styleMask = self.normalStyleMask; // set mask before changing frame
    self.frame = self.normalFrame;
    self.level = self.normalLevel;
    self.opaque = self.normalOpaque;
    self.hidesOnDeactivate = self.normalHidesOnDeactivate;
    if (!CGSizeEqualToSize(_normalAspect, CGSizeZero)) {
      self.contentAspectRatio = _normalAspect;
    }
    [self addScreenButton];
  }
  [DEL_RESPONDS(windowChangedCoversScreen:) windowChangedCoversScreen:self];
}


- (void)toggleCoversScreen {
  self.coversScreen = !self.coversScreen;
}


- (void)keyDown:(NSEvent *)event {
  if (_coversScreen && [event keyCode] == 53) { // escape key
    // nop to prevent system beep
  }
  else {
    [super keyDown:event];
  }
}


- (void)keyUp:(NSEvent *)event {
  if (_coversScreen && [event keyCode] == 53) { // escape key
    [self toggleCoversScreen];
  }
  else {
    [super keyUp:event];
  }
}


- (void)screenDidChange:(NSNotification *)notification {
  errFL(@"window: %p screenDidChange:; scale: %f", self, self.screen.backingScaleFactor);
  CGFloat sf = self.screen.backingScaleFactor;
  [self.contentView layer].contentsScale = sf;
  self.view.layer.contentsScale = sf;
  [DEL_RESPONDS(windowChangedScreen:) windowChangedScreen:self];
}


- (void)setContentSizeAndAspect:(CGSize)size {
  LOG_METHOD;
  CGPoint p = self.position;
  self.contentSize = size;
  self.contentAspectRatio = size;
  _normalAspect = size;
  self.position = p;
}

@end
