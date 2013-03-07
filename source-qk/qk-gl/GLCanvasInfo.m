// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSString+QK.h"
#import "GLCanvasInfo.h"


@interface GLCanvasInfo ()
@end


@implementation GLCanvasInfo


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: s: %@; vr: %@; zs: %f>",
          self.class, self, NSStringFromCGSize(_size), NSStringFromCGRect(_visibleRect), _zoomScale];
}


@end

