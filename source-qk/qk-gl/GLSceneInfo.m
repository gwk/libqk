// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "GLSceneInfo.h"


@interface GLSceneInfo ()
@end


@implementation GLSceneInfo


- (NSString*)description {
  return [NSString withFormat:@"<%@ %p: cs: %@; vr: %@; zs: %f>",
          self.class, self, NSStringFromCGSize(_contentSize), NSStringFromCGRect(_visibleRect), _zoomScale];
}


@end

