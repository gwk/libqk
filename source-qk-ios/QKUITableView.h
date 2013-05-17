// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"


typedef CGFloat (^BlockRowHeight)(NSIndexPath*, id); // takes an index path and row; returns a height.
typedef NSString* (^BlockRowIdentifier)(NSIndexPath*, id); // takes and index path and row; returns cell reuse identifier.
typedef void (^BlockConfigureCell)(UITableViewCell*, NSIndexPath*, id); // takes a cell, index path and row; configures cell.
typedef NSIndexPath* (^BlockWillSelect)(NSIndexPath*, id); // takes an index path and a row; returns index path to select or nil.
typedef void (^BlockRowDo)(NSIndexPath*, id); // takes an index path and row; performs an action.

@interface QKUITableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray* rows;
@property (nonatomic, copy) BlockRowHeight blockRowHeight;
@property (nonatomic, copy) BlockRowIdentifier blockRowIdentifier;
// NUTE: untyped block so that block literals may declare cell argument with appropriate subclass.
// TODO: add a runtime block type check assertion to block property setters.
@property (nonatomic, copy) id blockConfigureCell;
@property (nonatomic, copy) BlockWillSelect blockWillSelect;
@property (nonatomic, copy) BlockRowDo blockDidSelect; // BlockRowDo


DEC_INIT(Frame:(CGRect)frame rows:(NSArray *)rows cellTypes:(id)cellTypes);

- (void)setRows:(NSArray *)rows reload:(BOOL)reload;
- (id)rowAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*)selectedCell;
- (void)deselectAnimated:(BOOL)animated;

@end
