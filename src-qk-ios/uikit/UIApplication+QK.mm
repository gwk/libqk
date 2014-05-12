// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "UIApplication+QK.h"


NSString* soundServicesErrorDesc(int code) {
    switch (code) {
            CASE_RET_TOK_STR(kAudioServicesNoError);
            CASE_RET_TOK_STR(kAudioServicesUnsupportedPropertyError);
            CASE_RET_TOK_STR(kAudioServicesBadPropertySizeError);
            CASE_RET_TOK_STR(kAudioServicesBadSpecifierSizeError);
            CASE_RET_TOK_STR(kAudioServicesSystemSoundUnspecifiedError);
            CASE_RET_TOK_STR(kAudioServicesSystemSoundClientTimedOutError);
        default: return @"unknown";
    }
}


void soundCheckCompleted(SystemSoundID soundID, void* ctx) {
    NSDictionary* d = (__bridge_transfer NSDictionary*)ctx;
    NSDate* date = d[@"date"];
    NSTimeInterval interval = [date timeIntervalSinceNow];
    NSTimer* timer = d[@"timer"];
    [timer invalidate];
    BlockDoBool block = d[@"block"];
    SystemSoundID soundId = [d[@"soundId"] unsignedIntValue];
    
    AudioServicesRemoveSystemSoundCompletion(soundId);
    AudioServicesDisposeSystemSoundID(soundId);
    block(-interval > .1); // soundCheck.caf must be longer than this interval.
}


void soundCheckFailed(SystemSoundID soundId, BlockDoBool block) {
    NSLog(@"soundCheckFailed: %lu", (Uns)soundId);
    AudioServicesRemoveSystemSoundCompletion(soundId);
    AudioServicesDisposeSystemSoundID(soundId);
    block(NO);
}


@implementation UIApplication (QK)


+ (BOOL)soundCheck:(BlockDoBool)block {
    LOG_METHOD;
    qk_assert(block, @"nil block");
    SystemSoundID soundId = 0;
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"soundCheck" withExtension:@"caf"];
    OSStatus code = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    if (code != kAudioServicesNoError) {
        NSLog(@"soundCheck: setup failed; error: %@", soundServicesErrorDesc(code));
        return NO;
    }
    qk_assert(soundId, @"AudioServicesCreateSystemSoundID returned soundId of 0");
    UInt32 yes = 1;
    code = AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(soundId), &soundId, sizeof(yes), &yes);
    if (code != kAudioServicesNoError) {
        NSLog(@"soundCheck: set property IsUISound failed: %@", soundServicesErrorDesc(code));
        return NO;
    }

    NSTimer * timer = [NSTimer withDelay:.5 tracking:YES block:^(NSTimer* t){ soundCheckFailed(soundId, block); }];
    
    NSDictionary* info =
    @{@"block" : block,
      @"date" : [NSDate date],
      @"soundId" : @(soundId),
      @"timer" : timer};
    
    code = AudioServicesAddSystemSoundCompletion(soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode, soundCheckCompleted, (__bridge_retained void*)info);
    if (code != kAudioServicesNoError) {
        NSLog(@"soundCheck: set SoundCompletion failed: %@", soundServicesErrorDesc(code));
        return NO;
    }
    AudioServicesPlaySystemSound(soundId);
    
    return YES;
}


@end
