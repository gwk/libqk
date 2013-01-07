// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "NSArray+QK.h"
#import "NSString+QK.h"


@implementation NSString (Oro)


+ (id)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
  NSString* s;
  va_list args;
  va_start(args, format);
  s = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);
  return s;
}


#pragma mark - UTF


+ (id)withUtf8:(Utf8)string {
  if (!string) {
    return nil;
  }
  return [self stringWithUTF8String:string];
}


+ (id)withUtf32:(Utf32)string {
  ASSERT_WCHAR_IS_UTF32;
  if (!string) {
    return nil;
  }
  int length = 0;
  while (string[length]) length++; // count non-null 4-byte characters.
  return [[self alloc] initWithBytes:string length:length * 4 encoding:NSUTF32LittleEndianStringEncoding];
}


+ (id)withUtf8M:(Utf8M)string free:(BOOL)freeString {
  if (!string) {
    return nil;
  }
  id s = [self stringWithUTF8String:string];
  if (freeString) {
    free(string);
  }
  return s;
}


+ (id)withUtf32M:(Utf32M)string free:(BOOL)freeString {
  if (!string) {
    return nil;
  }
  assert(sizeof(wchar_t) == 4, @"bad wchar size");
  int length = 0;
  while (string[length]) length++; // count non-null 4-byte characters.
  id s = [[self alloc] initWithBytes:string length:length * 4 encoding:NSUTF32LittleEndianStringEncoding];
  if (freeString) {
    free(string);
  }
  return s;
}


- (void*)asUtfNew:(NSStringEncoding)encoding pad:(NSUInteger)pad {
  
  NSUInteger len = [self lengthOfBytesUsingEncoding:encoding];
  
  void* bytes = malloc(len + pad);
  
  NSUInteger len_act;
  NSRange range_left;
  
  [self getBytes:bytes
       maxLength:len
        usedLength:&len_act
        encoding:encoding
         options:0
           range:NSRangeLength(self)
  remainingRange:&range_left];
  
  assert(len_act == len, @"Utf32 buffer filled %lu; expected %lu", (unsigned long)len_act, (unsigned long)len);
  assert(!range_left.length, @"Utf32 buffer could not be filled; terminated at position %lu", (unsigned long)range_left.location);
  
  memset(bytes + len, 0, pad); // null terminate
  return bytes;
}


- (Utf8M)asUtf8M {
  return [self asUtfNew:NSUTF8StringEncoding pad:1];
}


- (Utf32M)asUtf32M {
  return [self asUtfNew:NSUTF32LittleEndianStringEncoding pad:4];
}


- (Utf8)asUtf8 NS_RETURNS_INNER_POINTER {
  return self.UTF8String;
}


- (Utf32)asUtf32 NS_RETURNS_INNER_POINTER {
  // create an autoreleased NSData object; return the bytes inner pointer, which will be released in the same scope.
  return [[NSData dataWithBytesNoCopy:self.asUtf32M
                              length:(self.length + 1) * 4
                        freeWhenDone:YES] bytes];
}


#pragma mark - numbered lines


- (NSString*)numberedLinesFrom:(Int)from {
  NSArray* a = [self componentsSeparatedByString:@"\n"];
  NSArray* an = [a mapIndexed:^(NSString* line, Int index){
    return [NSString withFormat:@"%3ld: %@", index, line];
  }];
  return [an componentsJoinedByString:@"\n"];
}


- (NSString*)numberedLines {
  return [self numberedLinesFrom:1];
}

- (NSString*)numeberedLinesFrom0 {
  return [self numberedLinesFrom:0];
}


@end


#pragma mark - UTF autorelease

Utf8 Utf8AR(Utf8 string) {
  return [[NSString withUtf8:string] asUtf8];
}


Utf32 Utf32AR(Utf32 string) {
  return [[NSString withUtf32:string] asUtf32];
}


Utf32 Utf32With8(Utf8 string) {
  return [[NSString withUtf8:string] asUtf32];
}


Utf8 Utf8With32(Utf32 string) {
  return [[NSString withUtf32:string] asUtf8];
}


Utf32 Utf32MWith8(Utf8 string) {
  return [[NSString withUtf8:string] asUtf32M];
}


Utf8 Utf8MWith32(Utf32 string) {
  return [[NSString withUtf32:string] asUtf8M];
}

