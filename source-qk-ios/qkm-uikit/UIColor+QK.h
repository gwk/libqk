// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIColor (QK)

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat l;
@property (nonatomic, readonly) CGFloat a;

+ (id)clear;

+ (id)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
+ (id)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
+ (id)l:(CGFloat)l a:(CGFloat)a;
+ (id)l:(CGFloat)l;

+ (id)r:(CGFloat)r;
+ (id)g:(CGFloat)g;
+ (id)b:(CGFloat)b;
+ (id)r:(CGFloat)r a:(CGFloat)a;
+ (id)g:(CGFloat)g a:(CGFloat)a;
+ (id)b:(CGFloat)b a:(CGFloat)a;

@end

