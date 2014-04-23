// Copyright 2014 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface NSFileManager (QK)

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

+ (NSArray*)contentsOfDir:(NSString*)dir error:(NSError**)errorPtr;

@end

