// Copyright 2014 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-types.h"
#import "CRFont.h"
#import "CRColor.h"

#if OBJCPP
NSMutableDictionary* strAttrs(CRFont* font = nil,
                              CRColor* color = nil,
                              NSTextAlignment align = NSTextAlignmentNatural);
#endif


@interface NSAttributedString (QK)

+ (instancetype)withString:(NSString*)string attrs:(NSDictionary*)attrs;

@end

