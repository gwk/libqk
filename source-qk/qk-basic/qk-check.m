// Copyright 2010 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"
#import "qk-check.h"


void __attribute__((noreturn))
_qk_fail(Ascii file, int line, Ascii func, Ascii expr_str, NSString* msg) {
  NSLog(@"ERROR: check failed: %s:%d: %s\n%s\n%@\n", __FILE__, __LINE__, __func__, expr_str, msg);

#if !NFAILTHROWS
  [[NSAssertionHandler currentHandler]
   handleFailureInFunction:[NSString stringWithUTF8String:func]
   file:[NSString stringWithUTF8String:file]
   lineNumber:line
   description:@"%s\n%@", expr_str, msg];
#endif // NFAILTHROWS
  
  abort();
}


void _qk_pseudo_breakpoint(const char* file, int line, const char* func) {
  fprintf(stderr, "((( %s, %s, line %d; press return to continue )))", func, file, line);
  const int size = 256;
  char input[size];
  while (fgets(input, size, stdin)) {
    char* found_newline = strchr(input, '\n');
    if (found_newline) return;
  }
}
