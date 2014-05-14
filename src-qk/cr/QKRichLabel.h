// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-block-types.h"
#import "qk-cr.h"
#import "QKLitView.h"


@interface QKRichLabel : CRView <QKLitView>

@property (nonatomic) BOOL isLit; // QKLitView; alias for highlighted. TODO.
@property (nonatomic) NSAttributedString* richText;
//@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic) QKVertAlignment vertAlignment;

@end

