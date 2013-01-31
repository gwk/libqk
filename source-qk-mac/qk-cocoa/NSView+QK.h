// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import <Cocoa/Cocoa.h>

typedef Int UIViewAutoresizing;

extern const UIViewAutoresizing UIFlexNone;
extern const UIViewAutoresizing UIFlexWidth;
extern const UIViewAutoresizing UIFlexHeight;
extern const UIViewAutoresizing UIFlexLeft;
extern const UIViewAutoresizing UIFlexRight;
extern const UIViewAutoresizing UIFlexTop;
extern const UIViewAutoresizing UIFlexBottom;

extern const UIViewAutoresizing UIFlexSize;
extern const UIViewAutoresizing UIFlexHorizontal;
extern const UIViewAutoresizing UIFlexVertical;


@interface NSView (QK)

- (void)inspect:(NSString*)label;
- (void)inspectParents:(NSString*)label;

@end
