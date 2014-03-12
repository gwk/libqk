  // Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "UIViewController+QK.h"
#import "QKDuo.h"
#import "TestScrollController.h"
#import "TestTableController.h"
#import "TestGLScrollController.h"
#import "RootController.h"
#import "TestLabelController.h"
#import "TestJpgController.h"


@interface RootController ()
@end


@implementation RootController


- (id)init {
  auto rows =
  @[[QKDuo a:@"Scroll View" b:[TestScrollController class]],
    [QKDuo a:@"Table View" b:[TestTableController class]],
    [QKDuo a:@"GL Scroll View" b:[TestGLScrollController class]],
    [QKDuo a:@"Labels" b:[TestLabelController class]],
    [QKDuo a:@"JPEG" b:[TestJpgController class]]];
  
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
