// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-cr.h"

@interface CRColor (CR)

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat l;
@property (nonatomic, readonly) CGFloat a;

+ (instancetype)clear;
+ (instancetype)w;
+ (instancetype)k;

+ (instancetype)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
+ (instancetype)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
+ (instancetype)l:(CGFloat)l a:(CGFloat)a;
+ (instancetype)l:(CGFloat)l;

+ (instancetype)r;
+ (instancetype)g;
+ (instancetype)b;

+ (instancetype)r:(CGFloat)r;
+ (instancetype)g:(CGFloat)g;
+ (instancetype)b:(CGFloat)b;
+ (instancetype)r:(CGFloat)r a:(CGFloat)a;
+ (instancetype)g:(CGFloat)g a:(CGFloat)a;
+ (instancetype)b:(CGFloat)b a:(CGFloat)a;

@end
