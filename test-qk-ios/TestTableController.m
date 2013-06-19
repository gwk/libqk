// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-cg-util.h"
#import "NSArray+QK.h"
#import "NSString+QK.h"
#import "CUIView.h"
#import "UIColor+QK.h"
#import "QKTableView.h"
#import "QKLabel.h"
#import "TestTableController.h"


@interface TestTableController ()
@end


@implementation TestTableController


PROPERTY_SUBCLASS_ALIAS(QKTableView, tableView, TableView, self.view);


#pragma mark - UIView


- (void)loadView {
  NSArray* rows = [NSArray mapIntTo:64 block:^(Int i){ return [NSString withFormat:@"%ld", i]; }];
  
  self.tableView = [QKTableView withFlexFrame:CGRect256
                             scrollHorizontal:YES
                                         rows:rows
                                  constructor:^(int type){
                                    return [QKLabel withFrame:CGRectMake(0, 0, 320, 24)];
                          }
                                      rowType:nil
                                    configure:^(QKLabel* cell, NSIndexPath* path, NSString* row){
                                      cell.width = 480;
                                      cell.text = row;
                                      cell.color = [UIColor l:(1 - ([path indexAtPosition:0] % 2) * .05)];
  }];
  self.tableView.backgroundColor = [UIColor r:1];
}


@end

