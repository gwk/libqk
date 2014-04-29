// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-cg-util.h"
#import "QKTableController.h"


@interface QKTableController ()
@end


@implementation QKTableController


- (void)loadView {
  self.view = [QKUITableView withFrame:CGRect256 rows:_rows cellTypes:_cellTypes];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView deselectAnimated:animated];
}


DEF_INIT(Rows:(NSArray*)rows cellTypes:(id)cellTypes) {
  INIT(super init);
  _rows = rows;
  _cellTypes = cellTypes;
  return self;
}


PROPERTY_SUBCLASS_ALIAS(QKUITableView, tableView, TableView, self.view);


@end

