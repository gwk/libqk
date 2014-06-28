// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.

#import "qk-log.h"
#import "NSError+QK.h"
#import "NSString+QK.h"
#import "NSObject+JNB.h"
#import "QKImage+PNG.h"
#import "QKImage+JPG.h"


NSString* convert_from_jnb(NSString* src_path, NSString* dst_path) {
  return @"unimplemented";
}


// return an error string or nil for success.
NSString* convert_to_jnb(NSString* fmt_str, NSString* src_path, NSString* dst_path) {
  QKPixFmt fmt =QKPixFmtFromString(fmt_str);
  if (!fmt) {
    return [NSString withFormat:@"unkown format: %@", fmt_str];
  }
  auto ext = src_path.pathExtension;
  QKImage* image;
  NSError* e = nil;
  if ([ext isEqualToString:@"png"]) {
    image = [QKImage withPngPath:src_path map:NO fmt:fmt error:&e];
  }
  else if ([ext isEqualToString:@"jpg"]) {
    image = [QKImage withJpgPath:src_path map:NO fmt:fmt error:&e];
  }
  if (e) {
    return e.description;
  }
  errFL(@"%@: %@ -> %@", image.formatDesc, src_path, dst_path);
  return [image writeJnbToPath:dst_path].description;
}


int main(int argc, char *argv[]) {
  @autoreleasepool {
    NSArray* args = [[NSProcessInfo processInfo] arguments];
    if (args.count == 3) { // from jnb to jpg or png.
      auto err_str = convert_from_jnb(args[1], args[2]);
      if (err_str) {
        errFL(@"error converting from jnb: %@", err_str);
        return 1;
      }
    } else if (args.count == 4) { // from jpg or png to jnb.
      id err_str = convert_to_jnb(args[1], args[2], args[3]);
      if (err_str) {
        errFL(@"error converting to jnb: %@", err_str);
      }
    } else {
      errFL(@"usage: to jnb:   jnb-img src_path.{jpg|png} dst_path.jnb format");
      errFL(@"usage: from jnb: jnb-img src_path.jnb dst_path.{jpg|png}");
      return 1;
    }
    return 0;
  }
}
