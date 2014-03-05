// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface UIApplication (QK)

#define DIR(n, N, e) \
+ (NSString*)n##Dir; \
+ (NSString*)pathFor##N:(NSString*)path;

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

