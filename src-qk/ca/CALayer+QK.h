// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface CALayer (QK)

- (void)inspect;
- (void)inspect:(NSString*)label;
- (void)inspectParents;
- (void)inspectParents:(NSString*)label;

@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat w;
@property(nonatomic) CGFloat h;
@property(nonatomic) CGFloat r;
@property(nonatomic) CGFloat b;
@property(nonatomic) CGFloat px;
@property(nonatomic) CGFloat py;

@end

