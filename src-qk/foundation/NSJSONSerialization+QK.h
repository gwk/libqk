// Copyright 2013 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


@interface NSJSONSerialization (QK)

+ (id)objectFromFilePath:(NSString*)path options:(NSJSONReadingOptions)opt error:(NSError **)error;

@end

