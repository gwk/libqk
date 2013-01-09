// Copyright George King 2013.
// Permission to use this file is granted in libqk/license.txt.


#import "sqlite3.h"
#import "SqlStatement.h"


@interface SqlDatabase : NSObject

@property (nonatomic, readonly) NSString* path;
@property (nonatomic, readonly) sqlite3* handle;

+ (id)withPath:(NSString*)path writeable:(BOOL)writeable create:(BOOL)create;

+ (id)named:(NSString*)resourceName; // readonly resource database

- (SqlStatement*)prepare:(NSString*)string;
- (SqlStatement*)prepareInsert:(int)count table:(NSString*)table;

@end

