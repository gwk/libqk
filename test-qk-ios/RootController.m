// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "UIViewController+QK.h"
#import "QKDuo.h"
#import "ScrollController.h"
#import "RootController.h"
#import "LabelController.h"


@interface RootController ()
@end


@implementation RootController


- (id)init {
  NSArray* rows =
  @[
    [QKDuo a:@"Scroll View" b:[ScrollController class]],
    [QKDuo a:@"Labels" b:[LabelController class]],
    ];
  
  INIT(super initWithRows:rows cellTypes:nil);
  BLOCK(self);
  self.tableView.blockConfigureCell = ^(UITableViewCell* cell, NSIndexPath* indexPath, QKDuo* row) {
    cell.textLabel.text = row.a;
  };
  self.tableView.blockDidSelect = ^(NSIndexPath* indexPath, QKDuo* row){
    Class c = row.b;
    UIViewController* controller = [c new];
    [block_self push:controller];
  };
  return self;
}



  
@end

