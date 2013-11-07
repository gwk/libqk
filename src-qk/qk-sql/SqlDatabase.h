// Copyright George King 2013.
// Permission to use this file is granted in libqk/license.txt.


#import "sqlite3.h"
#import "SqlStatement.h"


@interface SqlDatabase : NSObject

@property (nonatomic, readonly) NSString* path;
@property (nonatomic, readonly) sqlite3* handle;
@property (nonatomic, readonly) I64 lastId;

+ (id)withPath:(NSString*)path writeable:(BOOL)writeable create:(BOOL)create;

+ (id)named:(NSString*)resourceName; // readonly resource database

- (SqlStatement*)prepare:(NSString*)query;
- (SqlStatement*)prepareInsert:(int)count table:(NSString*)table;

- (void)execute:(NSString*)query;
- (void)log:(NSString*)query;

- (void)commit;

@end

