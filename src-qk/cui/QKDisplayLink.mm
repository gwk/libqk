// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "NSTimer+QK.h"
#import "QKDisplayLink.h"


@interface QKDisplayLink ()

@property(nonatomic) BOOL tracking;
@property(nonatomic, strong) BlockDisplayLink block;
#if TARGET_OS_IPHONE
@property(nonatomic) CADisplayLink* displayLink;
#else
@property(nonatomic) NSTimer* timer;
#endif

@end


@implementation QKDisplayLink


- (void)dealloc {
#if TARGET_OS_IPHONE
  [_displayLink invalidate];
#else
  [_timer invalidate];
#endif
}


DEF_INIT(Tracking:(BOOL)tracking block:(BlockDisplayLink)block) {
  INIT(super init);
  _tracking = tracking;
  _block = block;
#if TARGET_OS_IPHONE
  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(invokeBlock)];
  [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(tracking ? NSRunLoopCommonModes : NSDefaultRunLoopMode)];
#else
  [self createTimer];
#endif
  return self;
}


- (void)setPaused:(BOOL)paused {
  _paused = paused;
#if TARGET_OS_IPHONE
  _displayLink.paused = paused;
#else
  if (_paused) {
    [_timer invalidate];
    _timer = nil;
  }
  else {
    [self createTimer];
  }
#endif
}


#if TARGET_OS_IPHONE

- (void)invokeBlock {
  if (!_paused) {
    _block(self);
  }
}

#else

- (void)createTimer {
  WEAK(self);
  qk_assert(!_timer, @"timer already exists");
  _timer = [NSTimer withInterval:(1.0 / 60.0) tracking:_tracking block:^(NSTimer* t){
    _block(weak_self);
  }];
}

#endif


@end
