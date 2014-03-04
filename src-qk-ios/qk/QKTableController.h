// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-macros.h"
#import "QKViewController.h"
#import "QKUITableView.h"


@interface QKTableController : QKViewController

@property (nonatomic) NSArray* rows;
@property (nonatomic) id cellTypes;
@property (nonatomic) QKUITableView* tableView;

DEC_INIT(Rows:(NSArray*)rows cellTypes:(id)cellTypes);

@end

