// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "NSArray+QK.h"
#import "UITableViewCell+QK.h"
#import "QKUITableView.h"


static NSString* const defaultCellIdentifier = @"default-identifier";


@interface QKUITableView ()

@property (nonatomic) NSMutableDictionary* identifierCellClasses;

@end


@implementation QKUITableView



#pragma mark - UITableView


- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
  [super registerClass:cellClass forCellReuseIdentifier:identifier];
  if (cellClass) {
    _identifierCellClasses[identifier] = cellClass;
  }
  else {
    [_identifierCellClasses removeObjectForKey:identifier];
  }
}


#pragma mark - UITableViewDataSource


#define ASSERT_SELF \
qk_assert(tableView == self, @"QKUITableView %@ received data source / delegate call or another table view: %@", self, tableView)

#define DEF_ROW \
id row = [self rowAtIndexPath:indexPath];

#define DEF_IDENTIFIER \
NSString* identifier = _blockRowIdentifier ? _blockRowIdentifier(indexPath, row) : defaultCellIdentifier;


- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  ASSERT_SELF;
  return 1;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  ASSERT_SELF;
  return _rows.count;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  ASSERT_SELF;
  DEF_ROW;
  if (_blockRowHeight) {
    return _blockRowHeight(indexPath, row);
  }
  DEF_IDENTIFIER;
  Class c = _identifierCellClasses[identifier];
  return [c heightForRow:row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ASSERT_SELF;
  DEF_ROW;
  DEF_IDENTIFIER;
  UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  if (_blockConfigureCell) {
    _blockConfigureCell(cell, indexPath, row);
  }
  else {
    [cell configureWithRow:row];
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


// - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {}

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
  _identifierCellClasses = [NSMutableDictionary new];
  self.dataSource = self;
  self.delegate = self;
  CGFloat rh = 1024; // pick a default rowHeight for empty table; start large for MIN reduction.
  if (IS_KIND(cellTypes, NSArray)) {
    for (Class cellClass in cellTypes) {
      rh = MIN(rh, [cellClass heightForRow:nil]);
      [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
  }
  else if (IS_KIND(cellTypes, NSDictionary)) {
    for (NSString* identifier in cellTypes) {
      Class cellClass = cellTypes[identifier];
      rh = MIN(rh, [cellClass heightForRow:nil]);
      [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
  }
  else { // assume cellTypes is a single cell class or else nil, in which case default to base cell class.
    Class c = (cellTypes ? cellTypes : [UITableViewCell class]);
    rh = [c heightForRow:nil];
    [self registerClass:c forCellReuseIdentifier:defaultCellIdentifier];
  }
  self.rowHeight = rh;
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
