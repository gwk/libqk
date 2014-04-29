// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "CUIView.h"
#import "CUIColor.h"
//#import "QKButton.h"
#import "QKScrollView.h"
#import "TestScrollController.h"


@interface TestScrollController ()

@property (nonatomic) UIScrollView* scrollView;

@end


@implementation TestScrollController


#pragma mark - UIView


- (void)viewDidLoad {
  _scrollView = [QKScrollView withFlexFrame:self.view.bounds];
  [self.view addSubview:_scrollView];
  _scrollView.delaysContentTouches = YES;
  _scrollView.backgroundColor = [UIColor l:.5];
  CGFloat size = 768;
  _scrollView.contentSize = CGSizeMake(size, size);
  _scrollView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
  CGFloat step = 64;
  for_imns(i, step, size, step) {
    UIView* h = [UIView withFrame:CGRectMake(0, i, size, 2)];
    UIView* v = [UIView withFrame:CGRectMake(i, 0, 2, size)];
    h.backgroundColor = [UIColor l:.6];
    v.backgroundColor = [UIColor l:.6];
    [_scrollView addSubview:h];
    [_scrollView addSubview:v];
  }
  /*
  QKButton* button = [QKButton withFrame:CGRectMake(32, 32, 96, 64)];
  button.text = @"Button";
  button.blockTouchDown = ^{
    errL(@"touch down");
  };
  button.blockTouchUp = ^{
    errL(@"touch up");
  };
  button.blockTouchCancelled = ^{
    errL(@"touch cancelled");
  };
  [cv addSubview:button];
   */
}


@end

