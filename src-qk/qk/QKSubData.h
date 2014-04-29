// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "QKData.h"


@interface QKSubData : NSObject <QKData>

@property (nonatomic, readonly) id<QKData> data;
@property (nonatomic, readonly) const void* bytes;
@property (nonatomic, readonly) Int length;

- (id)initWithData:(id<QKData>)data offset:(Int)offset length:(Int)length;
+ (id)withData:(id<QKData>)data offset:(Int)offset length:(Int)length;

@end

