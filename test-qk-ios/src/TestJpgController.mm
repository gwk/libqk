// Copyright 2014 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-log.h"
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
  self.view.backgroundColor = [UIColor l:.5];
  _imageView = [UIImageView withFlexFrame:self.view.bounds];
  [self.view addSubview:_imageView];
  _imageView.contentMode = UIViewContentModeScaleAspectFit;
  NSString* path = [NSBundle resPath:@"dancing-squirrel.jpg"];
  NSError* e;
  auto image = [QKImage withJpgPath:path map:NO fmt:QKPixFmtRGBU8 div:1 error:&e];
  //[image rotateQCW];
  qk_check(!e, @"jpg open failed: %@", e);
  _imageView.image = image.uiImage;
  LOG([QKImage propertiesForImageAtPath:path]);
}


@end

