// Copyright 2014 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <sys/types.h>
#import <sys/sysctl.h>

#import "UIDevice+QK.h"


@implementation UIDevice (QK)


+ (NSString*)getSysInfoByName:(const char*)name {
  size_t size;
  sysctlbyname(name, NULL, &size, NULL, 0);
  char* string = (char*)malloc(size);
  sysctlbyname(name, string, &size, NULL, 0);
  NSString *results = [NSString stringWithCString:string encoding: NSUTF8StringEncoding];
  free(string);
  return results;
}


+ (NSString*)sysMachine {
  return [self getSysInfoByName:"hw.machine"];
}


+ (NSString*)sysModel {
  return [self getSysInfoByName:"hw.model"];
}


+ (NSString*)sysMachineModel {
  static auto s = [NSString withFormat:@"%@:%@", [self sysMachine], [self sysModel]];
  return s;
}


+ (NSString*)sysVersion {
  static auto s = [NSString withFormat:@"iOS_%@", [self currentDevice].systemVersion];
  return s;
}


+ (NSString*)identifier {
  static auto s = [self currentDevice].identifierForVendor.UUIDString;
  return s;
}


+ (NSString*)details {
  static auto s = [NSString withFormat:@"%@:%@:%@", [self sysMachineModel], [self sysVersion], [self identifier]];
  return s;
}


@end
