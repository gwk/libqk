// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UITableViewCell+QK.h"


@implementation UITableViewCell (QK)


+ (CGFloat)heightForRow:(id)row {
  return 64;
}


- (void)configureWithRow:(id)row {
  self.textLabel.text = [row description];
}


@end

