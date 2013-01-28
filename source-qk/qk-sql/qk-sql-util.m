// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-sql-util.h"


NSString* sql_failure_str(sqlite3* db, int code) {
  return [NSString withFormat:@"SQLite failure: %@\n%s\n", sql_code_description(code), sqlite3_errmsg(db)];
}


const char* sql_code_string(int code) {
  switch (code) {
      CASE_RET_TOK_UTF8(SQLITE_OK);
      CASE_RET_TOK_UTF8(SQLITE_ERROR);
      CASE_RET_TOK_UTF8(SQLITE_INTERNAL);
      CASE_RET_TOK_UTF8(SQLITE_PERM);
      CASE_RET_TOK_UTF8(SQLITE_ABORT);
      CASE_RET_TOK_UTF8(SQLITE_BUSY);
      CASE_RET_TOK_UTF8(SQLITE_LOCKED);
      CASE_RET_TOK_UTF8(SQLITE_NOMEM);
      CASE_RET_TOK_UTF8(SQLITE_READONLY);
      CASE_RET_TOK_UTF8(SQLITE_INTERRUPT);
      CASE_RET_TOK_UTF8(SQLITE_IOERR);
      CASE_RET_TOK_UTF8(SQLITE_CORRUPT);
      CASE_RET_TOK_UTF8(SQLITE_NOTFOUND);
      CASE_RET_TOK_UTF8(SQLITE_FULL);
      CASE_RET_TOK_UTF8(SQLITE_CANTOPEN);
      CASE_RET_TOK_UTF8(SQLITE_PROTOCOL);
      CASE_RET_TOK_UTF8(SQLITE_EMPTY);
      CASE_RET_TOK_UTF8(SQLITE_SCHEMA);
      CASE_RET_TOK_UTF8(SQLITE_TOOBIG);
      CASE_RET_TOK_UTF8(SQLITE_CONSTRAINT);
      CASE_RET_TOK_UTF8(SQLITE_MISMATCH);
      CASE_RET_TOK_UTF8(SQLITE_MISUSE);
      CASE_RET_TOK_UTF8(SQLITE_NOLFS);
      CASE_RET_TOK_UTF8(SQLITE_AUTH);
      CASE_RET_TOK_UTF8(SQLITE_FORMAT);
      CASE_RET_TOK_UTF8(SQLITE_RANGE);
      CASE_RET_TOK_UTF8(SQLITE_NOTADB);
      CASE_RET_TOK_UTF8(SQLITE_ROW);
      CASE_RET_TOK_UTF8(SQLITE_DONE);
    default: return "UNKNOWN";
  }
}


NSString* sql_code_description(int code) {
  switch (code) {
    case SQLITE_OK:         return @"SQLITE_OK - Successful result";
    case SQLITE_ERROR:      return @"SQLITE_ERROR - SQL error or missing database";
    case SQLITE_INTERNAL:   return @"SQLITE_INTERNAL - Internal logic error in SQLite";
    case SQLITE_PERM:       return @"SQLITE_PERM - Access permission denied";
    case SQLITE_ABORT:      return @"SQLITE_ABORT - Callback routine requested an abort";
    case SQLITE_BUSY:       return @"SQLITE_BUSY - The database file is locked";
    case SQLITE_LOCKED:     return @"SQLITE_LOCKED - A table in the database is locked";
    case SQLITE_NOMEM:      return @"SQLITE_NOMEM - A malloc() failed";
    case SQLITE_READONLY:   return @"SQLITE_READONLY - Attempt to write a readonly database";
    case SQLITE_INTERRUPT:  return @"SQLITE_INTERRUPT - Operation terminated by sqlite3_interrupt()*";
    case SQLITE_IOERR:      return @"SQLITE_IOERR - Some kind of disk I/O error occurred";
    case SQLITE_CORRUPT:    return @"SQLITE_CORRUPT - The database disk image is malformed";
    case SQLITE_NOTFOUND:   return @"SQLITE_NOTFOUND - NOT USED. Table or record not found";
    case SQLITE_FULL:       return @"SQLITE_FULL - Insertion failed because database is full";
    case SQLITE_CANTOPEN:   return @"SQLITE_CANTOPEN - Unable to open the database file";
    case SQLITE_PROTOCOL:   return @"SQLITE_PROTOCOL - NOT USED. Database lock protocol error";
    case SQLITE_EMPTY:      return @"SQLITE_EMPTY - Database is empty";
    case SQLITE_SCHEMA:     return @"SQLITE_SCHEMA - The database schema changed";
    case SQLITE_TOOBIG:     return @"SQLITE_TOOBIG - String or BLOB exceeds size limit";
    case SQLITE_CONSTRAINT: return @"SQLITE_CONSTRAINT - Abort due to constraint violation";
    case SQLITE_MISMATCH:   return @"SQLITE_MISMATCH - Data type mismatch";
    case SQLITE_MISUSE:     return @"SQLITE_MISUSE - Library used incorrectly";
    case SQLITE_NOLFS:      return @"SQLITE_NOLFS - Uses OS features not supported on host";
    case SQLITE_AUTH:       return @"SQLITE_AUTH - Authorization denied";
    case SQLITE_FORMAT:     return @"SQLITE_FORMAT - Auxiliary database format error";
    case SQLITE_RANGE:      return @"SQLITE_RANGE - 2nd parameter to sqlite3_bind out of range";
    case SQLITE_NOTADB:     return @"SQLITE_NOTADB - File opened that is not a database file";
    case SQLITE_ROW:        return @"SQLITE_ROW - sqlite3_step() has another row ready";
    case SQLITE_DONE:       return @"SQLITE_DONE - sqlite3_step() has finished executing";
    default:                return @"UNKNOWN - invalid code";
  }
}


