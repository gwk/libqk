// Copyright 2010 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import <stdio.h>
#import <string.h>

#import "qk-check.h"


void _qk_pseudo_breakpoint(const char* file, int line, const char* func) {
  fprintf(stderr, "((( %s, %s, line %d; press return to continue )))", func, file, line);
  const int size = 256;
  char input[size];
  while (fgets(input, size, stdin)) {
    char* found_newline = strchr(input, '\n');
    if (found_newline) return;
  }
}
