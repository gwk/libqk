// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "UITableViewCell+QK.h"


@implementation UITableViewCell (QK)


+ (CGFloat)heightForRow:(id)row {
  return 48;
}


- (void)configureWithRow:(id)row {
  self.textLabel.text = [row description];
}


@end

