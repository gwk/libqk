// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "NSArray+QK.h"
#import "NSMutableArray+QK.h"
#import "NSMutableDictionary+QK.h"
#import "CUIView.h"
#import "QKTableView.h"


static NSString* const defaultCellIdentifier = @"default-identifier";


@interface QKTableView ()

@property (nonatomic) NSMutableDictionary* reuseArrays;
@property (nonatomic) NSMutableArray* positions;
@property (nonatomic) int currentPositionIndex;

@end


@implementation QKTableView


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // TODO: cell recycling.
  CGPoint offset = CGPointZero; // TODO
  if (offset.y > 0) { // down
    
  }
  else if (offset.y < 0) { // up
    
  }
  [super scrollViewDidScroll:scrollView];
}



#pragma mark - QKScrollView


#pragma mark - QKTableView


DEF_INIT(FlexFrame:(CGRect)frame
         scrollHorizontal:(BOOL)scrollHorizontal
         rows:(NSArray *)rows
         constructor:(BlockRowCellConstructor)constructor
         rowType:(BlockRowType)blockRowType
         configure:(BlockConfigureCell)blockConfigureCell) {
  
  INIT(super initWithFlexFrame:frame);
  _scrollHorizontal = scrollHorizontal;
  _rows = rows;
  qk_assert(constructor, @"nil cell constructor");
  self.blockCellConstructor = constructor;
  self.blockRowType = blockRowType;
  self.blockConfigureCell = blockConfigureCell;
  _reuseArrays = [NSMutableDictionary new];
  _positions = [NSMutableArray new];
  [self reload];
  return self;
}


- (void)reload {
  self.contentOffset = CGPointZero;
  [self removeAllSubviews];
  [_positions removeAllObjects];
  CGFloat w = self.bounds.size.width; // if h-scroll, this may expand dynamically with flex.
  UIFlex flex = self.scrollHorizontal ? UIFlexN : UIFlexW;
  CGFloat y = 0;
  for_in(i, _rows.count) {
    NSIndexPath* path = [NSIndexPath indexPathWithIndex:i];
    id row = [self rowAtIndexPath:path];
    int type = _blockRowType ? _blockRowType(path, row) : 0;
    NSMutableArray* reuseArray = [_reuseArrays setDefaultWithClass:[NSMutableArray class] forKey:@(type)];
    UIView* cell = [reuseArray pop];
    if (!cell) {
      cell = _blockCellConstructor(type);
      cell.flex = flex;
    }
    cell.frame = CGRectMake(0, y, w, cell.h);
    APPLY_LIVE_BLOCK(_blockConfigureCell, cell, path, row);
    if (cell.w > w) {
      w = cell.w;
    }
    [self addSubview:cell];
    y = cell.b;
  }
  self.contentSize = CGSizeMake(w, y);
}


- (void)setRows:(NSArray*)rows reload:(BOOL)reload {
  _rows = rows;
  if (reload) {
    [self reload];
  }
}


- (void)setRows:(NSArray *)rows {
  [self setRows:rows reload:YES];
}


- (id)rowAtIndexPath:(NSIndexPath*)indexPath {
  if (!indexPath) return nil;
  return [_rows elAtIndexPath:indexPath];
}


@end
