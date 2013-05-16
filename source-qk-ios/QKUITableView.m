// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKUITableView.h"


static NSString* const defaultCellIdentifier = @"default-identifier";


@implementation QKUITableView


#pragma mark - UITableViewDataSource


#define ASSERT_SELF \
qk_assert(tableView == self, @"QKUITableView %@ received data source / delegate call or another table view: %@", self, tableView)


- (int)numberOfSectionsInTableView:(UITableView*)tableView {
  ASSERT_SELF;
  return 1;
}


- (int)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  ASSERT_SELF;
  return _rows.count;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  ASSERT_SELF;
  return _blockRowHeight ? _blockRowHeight(indexPath, [self rowAtIndexPath:indexPath]) : self.rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ASSERT_SELF;
  id row = [self rowAtIndexPath:indexPath];
  NSString* identifier = _blockRowIdentifier ? _blockRowIdentifier(indexPath, row) : defaultCellIdentifier;
  UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  if (_blockConfigureCell) {
    _blockConfigureCell(cell, indexPath, row);
  }
  else { // default for prototyping and debugging
    cell.textLabel.text = [row description];
  }
  return cell;
}


#pragma mark - UITableViewDelegate


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ASSERT_SELF;
  if (_blockWillSelect) {
    return _blockWillSelect(indexPath, [self rowAtIndexPath:indexPath]);
  }
  else {
    return (_blockDidSelect ? indexPath : nil);
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ASSERT_SELF;
  if (_blockDidSelect) {
    _blockDidSelect(indexPath, [self rowAtIndexPath:indexPath]);
  }
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {}

// - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex {}
// - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex {}
// - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex {}
// - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex {}


// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {}
// -(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {}


#pragma mark - QKUITableView


DEF_INIT(Frame:(CGRect)frame rows:(NSArray *)rows cellTypes:(id)cellTypes) {
  INIT(super initWithFrame:frame);
  _rows = rows;
  self.dataSource = self;
  self.delegate = self;
  if (IS_KIND(cellTypes, NSArray)) {
    for (Class cellClass in cellTypes) {
      [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
  }
  else if (IS_KIND(cellTypes, NSDictionary)) {
    for (NSString* identifier in cellTypes) {
      Class cellClass = cellTypes[identifier];
      [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
  }
  else { // assume cellTypes is a cell class or else nil
    Class c = (cellTypes ? cellTypes : [UITableViewCell class]);
    [self registerClass:c forCellReuseIdentifier:defaultCellIdentifier];
  }
  return self;
}


- (void)setRows:(NSArray *)rows reload:(BOOL)reload {
  _rows = rows;
  if (reload) {
    [self reloadData];
  }
}


- (void)setRows:(NSArray *)rows {
  [self setRows:rows reload:YES];
}


- (id)rowAtIndexPath:(NSIndexPath*)indexPath {
  if (!indexPath) return nil;
  return [_rows objectAtIndex:indexPath.row];
}


- (UITableViewCell*)selectedCell {
    return [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
}


- (void)deselectAnimated:(BOOL)animated {
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:animated];
}


@end
