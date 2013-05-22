// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"


@interface QKLabel : UILabel

@property (nonatomic) NSString* placeholder;

- (void)bindToModel:(id)model path:(NSString*)modelKeyPath transform:(BlockMap)viewTransform;

@end

