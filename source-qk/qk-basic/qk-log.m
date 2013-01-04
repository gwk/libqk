// Copyright 2009 George King.
// Permission to use this file is granted in libqk/license.txt.

// print to standard error without the verbosity of NSLog.


#import "NSString+QK.h"


void err_item(NSString* item, NSString* end) {
  fputs(item.description.asUtf8, stderr);
  if (end) {
    fputs(end.asUtf8, stderr);
  }
}


void err_items(NSArray* items, NSString* sep, NSString* end) {
  NSString* string = [items componentsJoinedByString:sep];
  err_item(string, end);
}


