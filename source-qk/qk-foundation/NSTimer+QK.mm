// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSTimer+QK.h"


static NSString* qkTimerKeyStartDate = @"qkTimerKeyStartDate";
static NSString* qkTimerKeyExpiration = @"qkTimerKeyExpiration";
static NSString* qkTimerKeyBlock = @"qkTimerKeyBlock";
static NSString* qkTimerKeyCompletion = @"qkTimerKeyCompletion";


@implementation NSTimer (QK)


- (void)dissolve {
    [self invalidate];
}


- (BOOL)checkExpiration {
  NSDictionary* info = self.userInfo;
  NSDate* expirationDate = [info objectForKey:qkTimerKeyExpiration];
  qk_assert(expirationDate, @"expiration date is missing: %@", self);
  if ([expirationDate compare:[NSDate date]] != NSOrderedDescending) {
     BlockTimer completion = [info objectForKey:qkTimerKeyCompletion];
    if (completion) {
      completion(self);
    }
    [self invalidate];
    return YES;
  }
  return NO;
}


+ (void)executeExpiringBlockTimer:(NSTimer*)timer {
  if ([timer checkExpiration]) {
    return;
  }
  BlockTimer block = [timer.userInfo objectForKey:qkTimerKeyBlock];
  qk_assert(block, @"timer block is missing: %@", timer);
  block(timer);
}


+ (void)executeBlockTimer:(NSTimer*)timer {
  BlockTimer block = [timer.userInfo objectForKey:qkTimerKeyBlock];
  qk_assert(block, @"timer block is missing: %@", timer);
  block(timer);
}


- (F32)lerpFactor {
  NSDictionary* info = self.userInfo;
  NSDate* s = [info objectForKey:qkTimerKeyStartDate];
  NSDate* e = [info objectForKey:qkTimerKeyExpiration];
  qk_assert(s && e, @"missing start/expiration date");
  NSDate* n = [NSDate date];
  NSTimeInterval total = [e timeIntervalSinceDate:s];
  NSTimeInterval elapsed = [n timeIntervalSinceDate:s];
  return elapsed / total;
}


- (F32)lerpFactorEaseInOut {
    F32 t = self.lerpFactor;
    F32 t2 = t * t;
    return (3 * t2) - (2 * t * t2);
}


+ (NSTimer*)withInterval:(NSTimeInterval)interval
                 repeats:(BOOL)repeats
                tracking:(BOOL)tracking
                  target:(id)target
                  action:(SEL)action
                    info:(NSDictionary*)info {
  
  NSTimer* t = [self timerWithTimeInterval:interval
                                    target:target
                                  selector:action
                                  userInfo:info
                                   repeats:repeats];
  
  [[NSRunLoop currentRunLoop] addTimer:t forMode:(tracking ? NSRunLoopCommonModes : NSDefaultRunLoopMode)];
  return t;
}


+ (NSTimer*)withInterval:(NSTimeInterval)interval
                tracking:(BOOL)tracking
                   block:(BlockTimer)block {
  
  return [self withInterval:interval
                    repeats:YES
                   tracking:tracking
                     target:self
                     action:@selector(executeBlockTimer:)
                       info:@{
           qkTimerKeyBlock : block,
          }];
}


+ (NSTimer*)withDelay:(NSTimeInterval)delay
             tracking:(BOOL)tracking
                block:(BlockTimer)block {
  
  return [self withInterval:delay
                    repeats:NO
                   tracking:tracking
                     target:self
                     action:@selector(executeBlockTimer:)
                       info:@{
           qkTimerKeyBlock : block,
          }];
}



+ (NSTimer*)withInterval:(NSTimeInterval)interval
              expiration:(NSTimeInterval)expiration
                tracking:(BOOL)tracking
                   block:(BlockTimer)block
              completion:(BlockTimer)completion {
  
  NSMutableDictionary* info = @{
                      qkTimerKeyStartDate : [NSDate date],
                      qkTimerKeyExpiration : [NSDate dateWithTimeIntervalSinceNow:expiration],
                      qkTimerKeyBlock : block
                      }.mutableCopy;
  if (completion) {
    [info setObject:completion forKey:qkTimerKeyCompletion];
  }
  return [self withInterval:interval
                   repeats:YES
                   tracking:tracking
                     target:self
                     action:@selector(executeExpiringBlockTimer:)
                       info:info];
}


@end

