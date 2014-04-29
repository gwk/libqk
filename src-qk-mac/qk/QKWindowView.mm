// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

// TODO: either use this to actually y-invert coordinate space or else remove it entirely.
// isFlipped does not propagate to subviews.


#import "qk-log.h"
#import "QKWindowView.h"


@implementation QKWindowView


- (id)initWithFrame:(NSRect)frame {
  LOG_METHOD;
  INIT(super initWithFrame:frame);
  [self setupLayer];
  //self.backgroundColor = [CUIColor r:.5];
  return self;
}

- (BOOL)isFlipped {
  return YES;
}

@end
