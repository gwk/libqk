// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UILabel+QK.h"


@implementation UILabel (QK)


#pragma mark - QKLitView


- (BOOL)isLit {
  return self.highlighted;
}


- (void)setIsLit:(BOOL)isLit {
  self.highlighted = isLit;
}


@end

