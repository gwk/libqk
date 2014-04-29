// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import <sqlite3.h>


// error description helpers
NSString* sql_failure_str(sqlite3* db, int code);
const char* sql_code_string(int code);
NSString* sql_code_description(int code);

