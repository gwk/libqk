// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIColor (QK)

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat w;
@property (nonatomic, readonly) CGFloat a;

+ (id)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
+ (id)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
+ (id)w:(CGFloat)w a:(CGFloat)a;
+ (id)w:(CGFloat)w;

@end

