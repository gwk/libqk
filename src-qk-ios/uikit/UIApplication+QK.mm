// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#import "qk-check.h"
#import "NSArray+QK.h"
#import "UIApplication+QK.h"


@implementation UIApplication (QK)


+ (NSString *)pathForStandardDir:(NSSearchPathDirectory)dir {
  static NSMutableDictionary* d = [NSMutableDictionary new];
  auto k = @(dir);
  NSString* path = d[k];
  if (path) return path;
  NSArray* paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
  qk_assert(paths.count == 1, @"no single path for dir: %ld; %@", (long)dir, paths);
  path = paths.el0;
  auto m = [NSFileManager defaultManager];
  BOOL isDir;
  if (![m fileExistsAtPath:path isDirectory:&isDir] && isDir) {
    NSError* e;
    BOOL success = [m createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&e];
    qk_assert(success, @"could not create standard dir: %@\n  error: %@", path, e);
  }
  d[k] = path;
  return path;
}


#define DIR(n, N, e) \
+ (NSString*)n##Dir { return [self pathForStandardDir:e]; } \
+ (NSString*)pathFor##N:(NSString*)path { return [self.n##Dir stringByAppendingPathComponent:path]; } \

DIR(autosave, Autosave, NSAutosavedInformationDirectory);
DIR(applicationSupport, ApplicationSupport, NSApplicationSupportDirectory);
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

