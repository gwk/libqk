// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface QKSubData : NSObject

@property (nonatomic, readonly) NSData* data;
@property (nonatomic, readonly) const void* bytes;
@property (nonatomic, readonly) Int length;
@property (nonatomic, readonly) BOOL isDataMutable;
@property (nonatomic, readonly) BOOL isDataMapped;

- (id)initWithData:(NSData*)data offset:(Int)offset length:(Int)length mapped:(BOOL)mapped;
+ (id)withData:(NSData*)data offset:(Int)offset length:(Int)length mapped:(BOOL)mapped;

@end

