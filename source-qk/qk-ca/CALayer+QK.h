// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface CALayer (QK)

- (void)inspectRec:(NSString*)indent;
- (void)inspect:(NSString*)label;
- (void)inspectParents:(NSString*)label;

@end

