// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "QKScrollView.h"


typedef UIView* (^BlockRowCellConstructor)(int); // takes a cell reuse enum value and returns a new cell view.
typedef int (^BlockRowType)(NSIndexPath*, id); // takes an index path and row; returns cell reuse enum value.
// NOTE: cell is untyped so that block literals can specify whatever type is appropriate for each case.
typedef void (^BlockConfigureCell)(id, NSIndexPath*, id); // takes a cell, index path and row; configures cell.


@interface QKTableView : QKScrollView

@property(nonatomic, readonly) BOOL scrollHorizontal;
@property(nonatomic) NSArray* rows;

@property (nonatomic, copy) BlockRowCellConstructor blockCellConstructor;
@property (nonatomic, copy) BlockRowType blockRowType;
@property (nonatomic, copy) BlockConfigureCell blockConfigureCell;

DEC_INIT(FlexFrame:(CGRect)frame
         scrollHorizontal:(BOOL)scrollHorizontal
         rows:(NSArray *)rows
         constructor:(BlockRowCellConstructor)constructor
         rowType:(BlockRowType)blockRowType
         configure:(BlockConfigureCell)blockConfigureCell);

- (void)setRows:(NSArray*)rows reload:(BOOL)reload;
- (void)reload;

- (id)rowAtIndexPath:(NSIndexPath*)indexPath;

@end
