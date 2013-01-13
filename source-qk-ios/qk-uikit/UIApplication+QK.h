// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface UIApplication (QK)

+ (NSString*)autosaveDir;
+ (NSString*)cacheDir;
+ (NSString*)documentDir;
+ (NSString*)downloadDir;
+ (NSString*)libraryDir;
+ (NSString*)movieDir;
+ (NSString*)musicDir;
+ (NSString*)pictureDir;
+ (NSString*)preferencePaneDir;
+ (NSString*)sharedPublicDir;

+ (NSString*)pathForAutosave:(NSString*)path;
+ (NSString*)pathForCache:(NSString*)path;
+ (NSString*)pathForDocument:(NSString*)path;
+ (NSString*)pathForDownload:(NSString*)path;
+ (NSString*)pathForLibrary:(NSString*)path;
+ (NSString*)pathForMovie:(NSString*)path;
+ (NSString*)pathForMusic:(NSString*)path;
+ (NSString*)pathForPicture:(NSString*)path;
+ (NSString*)pathForPreferencePane:(NSString*)path;
+ (NSString*)pathForSharedPublic:(NSString*)path;

@end

