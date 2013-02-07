// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-basic.h"
#import "qk-foundation.h"
#import "qk-jpg.h"
#import "qk-png.h"


// return an error string or nil for success.
NSString* convert(NSString* fmt_str, NSString* src_path, NSString* dst_path) {
  QKPixFmt fmt =QKPixFmtFromString(fmt_str);
  if (!fmt) {
    return [NSString withFormat:@"unkown format: %@", fmt_str];
  }
  NSString* ext = src_path.pathExtension;
  BOOL alpha = fmt & QKPixFmtBitA;
  QKImage* image;
  if ([ext isEqualToString:@"png"]) {
    image = [QKImage withPngPath:src_path alpha:alpha];
  }
  else if ([ext isEqualToString:@"jpg"]) {
    image = [QKImage withJpgPath:src_path alpha:alpha];
  }
  errFL(@"%@: %@ -> %@", image.formatDesc, src_path, dst_path);
  [image writeJnbToPath:dst_path];
  return nil;
}


int main(int argc, char *argv[]) {
  @autoreleasepool {
    NSArray* args = [[NSProcessInfo processInfo] arguments];
    if (args.count < 4) {
      errFL(@"usage: jnb-image-convert format src_path dst_path.jnb");
      return 1;
    }
    NSString* errorString = convert(args.el1, args.el2, args.el3);
    if (errorString) {
      errFL(@"error: %@", errorString);
      return 1;
    }
    return 0;
  }
}
