// Copyright 2013 George King.
// Permission to use this file is granted in oropendula/license.txt.


#import "QKWindow.h"


@interface QKWindow ()

@property (nonatomic) CGRect normalFrame;
@property (nonatomic) NSUInteger normalStyleMask;
@property (nonatomic) NSInteger normalLevel;
@property (nonatomic) BOOL normalOpaque;
@property (nonatomic) BOOL normalHidesOnDeactivate;
@property (nonatomic) NSButton* coverScreenButton;
@property (nonatomic) NSTimer* timer;

@end


@implementation QKWindow

@dynamic delegate; // redeclaration of super property.


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithView:(NSView *)view styleMask:(NSUInteger)styleMask {
  
  INIT(super initWithContentRect:view.frame styleMask:styleMask backing:NSBackingStoreBuffered defer:YES);
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(screenDidChange:)
                                               name:NSWindowDidChangeScreenNotification
                                             object:self];
  
  self.contentView = view;
  [self addCoverScreenButton];
  [self screenDidChange:nil]; // retina resolution factor is not recognized on first frame, so this is necessary.
  
  return self;
}


- (id)initWithView:(NSView *)view {
  
  NSUInteger styleMask =
  NSTitledWindowMask
  | NSClosableWindowMask
  | NSMiniaturizableWindowMask
  | NSResizableWindowMask;
  
  return [self initWithView:view styleMask:styleMask];
}


- (QKView*)qkView {
  return CAST(QKView, self.contentView);
}


- (void)setFrame:(CGRect)frame {
  [self setFrame:frame display:YES];
}


- (void)setOriginFromVisibleTopLeft:(CGPoint)origin {
  CGRect svf = self.screen.visibleFrame;
  CGFloat vsh = svf.origin.y + svf.size.height; // visible screen height accounts for possible menu bar
  CGFloat wh = self.frame.size.height;
  self.frameOrigin = CGPointMake(origin.x, vsh - (origin.y + wh));
}


// since the title bar gets removed on cover screen,
// we must add the button on init and every time we uncover.
- (void)addCoverScreenButton {
  // setup cover screen button
  NSView* windowView = [self.contentView superview];
  CGRect wf = windowView.frame;
  NSImage* image = [NSImage imageNamed:NSImageNameEnterFullScreenTemplate];
  CGSize s = image.size;
  CGRect frame = CGRectMake(wf.size.width - s.width - 3, wf.size.height - s.height - 3, s.width, s.height);
  
  if (!_coverScreenButton) {
    _coverScreenButton =  [[NSButton alloc] initWithFrame:frame];
    _coverScreenButton.target = self;
    _coverScreenButton.action = @selector(toggleCoversScreen);
    _coverScreenButton.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    _coverScreenButton.image = image;
    _coverScreenButton.bordered = NO;
    // TODO: fix white in highlight state.
  }
  
  [windowView addSubview:_coverScreenButton];
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
    [self addCoverScreenButton];
  }
  [self display];
}


- (void)toggleCoversScreen {
  self.coversScreen = !self.coversScreen;
}


- (void)keyUp:(NSEvent *)event {
  if (_coversScreen && [event keyCode] == 53) {
    [self toggleCoversScreen];
  }
  if ([self.delegate respondsToSelector:@selector(keyUp:)]) {
    [(NSResponder*)self.delegate keyUp:event];
  } 
}



- (void)screenDidChange:(NSNotification *)notification {
  errFL(@"window: %p screenDidChange:", self);
  CAST(NSView, self.contentView).layer.contentsScale = self.screen.backingScaleFactor;
  // should this notify handler?
}


@end
