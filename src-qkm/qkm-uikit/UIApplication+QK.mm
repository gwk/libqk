// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-check.h"
#import "NSArray+QK.h"
#import "UIApplication+QK.h"


@implementation UIApplication (QK)


+ (NSString *)pathForDir:(NSSearchPathDirectory)dir {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
  qk_assert(paths.count == 1, @"no single path for dir: %ld; %@", (long)dir, paths);
  return paths.el0;
}


#define DIR(n, N, e) \
+ (NSString*)n##Dir { return [self pathForDir:e]; } \
+ (NSString*)pathFor##N:(NSString*)path { return [self.n##Dir stringByAppendingPathComponent:path]; } \

DIR(autosave, Autosave, NSAutosavedInformationDirectory);
DIR(cache, Cache, NSCachesDirectory);
DIR(document, Document, NSDocumentDirectory);
DIR(download, Download, NSDownloadsDirectory);
DIR(library, Library, NSLibraryDirectory);
DIR(movie, Movie, NSMoviesDirectory);
DIR(music, Music, NSMusicDirectory);
DIR(picture, Picture, NSPicturesDirectory);
DIR(preferencePane, PreferencePane, NSPreferencePanesDirectory);
DIR(sharedPublic, SharedPublic, NSSharedPublicDirectory);

#undef DIR


@end

