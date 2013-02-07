// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKImage+JPG.h"


@implementation QKImage (JPG)


- (id)initWithJpgFile:(FILE*)file alpha:(BOOL)alpha {
  self = [self init];
  return self;
}


- (id)initWithJpgPath:(NSString*)path alpha:(BOOL)alpha {
  FILE* file = fopen(path.asUtf8, "rb");
  check(file, @"could not open file: %@", path);
  return [self initWithJpgFile:file alpha:alpha];
}


+ (id)withJpgPath:(NSString*)path alpha:(BOOL)alpha {
  return [[self alloc] initWithJpgPath:path alpha:alpha];
}


+ (QKImage*)jpgNamed:(NSString*)resourceName alpha:(BOOL)alpha {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  check(path, @"no image named: %@", resourceName);
  return [self withJpgPath:path alpha:alpha];
}



@end

