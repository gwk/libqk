// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@interface NSJSONSerialization (QK)

+ (id)JSONObjectFromFilePath:(NSString*)path options:(NSJSONReadingOptions)opt error:(NSError **)error;

@end

