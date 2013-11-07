// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk.h"
#import "qk-foundation.h"
#import "qk-jpg.h"
#import "qk-png.h"

#import "QKImage+PNG.h"
#import "QKImage+JPG.h"


// return an error object or nil for success.
id convert(NSString* fmt_str, NSString* src_path, NSString* dst_path) {
  QKPixFmt fmt =QKPixFmtFromString(fmt_str);
  if (!fmt) {
    return [NSString withFormat:@"unkown format: %@", fmt_str];
  }
  NSString* ext = src_path.pathExtension;
  BOOL alpha = fmt & QKPixFmtBitA;
  QKImage* image;
  NSError* e = nil;
  if ([ext isEqualToString:@"png"]) {
    image = [QKImage withPngPath:src_path map:NO alpha:alpha error:&e];
  }
  else if ([ext isEqualToString:@"jpg"]) {
    image = [QKImage withJpgPath:src_path map:NO alpha:alpha error:&e];
  }
  if (e) {
    return e;
  }
  errFL(@"%@: %@ -> %@", image.formatDesc, src_path, dst_path);
  return [image writeJnbToPath:dst_path];
}


int main(int argc, char *argv[]) {
  @autoreleasepool {
    NSArray* args = [[NSProcessInfo processInfo] arguments];
    if (args.count < 4) {
      errFL(@"usage: jnb-image-convert format src_path dst_path.jnb");
      return 1;
    }
    id error = convert(args.el1, args.el2, args.el3);
    if (error) {
      errFL(@"error: %@", error);
      return 1;
    }
    return 0;
  }
}
