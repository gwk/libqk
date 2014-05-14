// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-cr.h"
#import "CALayer+QK.h"


@interface QKTextLayer : CALayer

@property (nonatomic) NSAttributedString* richText;
@property (nonatomic) QKVertAlignment vertAlignment;

@end

