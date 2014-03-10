// Copyright 2014 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSBundle+QK.h"
#import "UIImage+QK.h"
#import "UIView+QK.h"
#import "QKImage+JPG.h"
#import "TestJpgController.h"


@interface TestJpgController ()

@property (nonatomic) UIImageView* imageView;

@end


@implementation TestJpgController


- (void)viewDidLoad {
  _imageView = [UIImageView withFlexFrame:self.view.bounds];
  [self.view addSubview:_imageView];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  NSError* e;
  auto image = [QKImage withJpgPath:[NSBundle resPath:@"nebula.jpg"] map:NO alpha:YES error:&e];
  qk_check(!e, @"jpg open failed");
  _imageView.image = image.uiImage;
}


@end

