// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-macros.h"
#import "qk-log.h"
#import "NSMutableData+QK.h"
#import "QKData.h"


@implementation NSObject (QKData)


- (NSMutableData*)mutableRowPointersForElSize:(I32)elSize width:(Int)width {
  id<QKData> data = CAST_PROTO(QKData, self);
  Int rowLength = elSize * width;
  Int rowCount = data.length / rowLength;
  NSMutableData* r = [NSMutableData withLength:sizeof(void*) * rowCount];
  U8* sb = (U8*)data.bytes;
  U8** rb = (U8**)r.mutableBytes;
  for_in(i, rowCount) {
    rb[i] = sb + i * rowLength;
  }
  return r;
}


- (NSData*)rowPointersForElSize:(I32)elSize width:(Int)width {
  return [self mutableRowPointersForElSize:elSize width:width];
}


- (NSString *)debugDataString:(Int)limit {
  id<QKData> data = CAST_PROTO(QKData, self);
  
  NSUInteger length = MIN(data.length, limit);
  const U8* bytes = (U8*)data.bytes;
  char* debugBytes = (char*)malloc(length);
  
  // convert problematic characters to readable characters in iso latin 1
  for (NSUInteger i = 0; i < length; i++) {
    int c = bytes[i];
    switch (c) {
      case 0:     c = 0xD8; break;    // null -> capital O slashed (looks like null symbol)
      case '\t':  c = 0xAC; break;    // tab -> not sign
      case '\n':  break;
      case '\r':  c = 0xAE; break;    // carriage return -> registered trademark sign
      default:
        if (iscntrl(c)) c = 0xA9;   // c < 0x20, 0x7F (C0 code) -> copyright sign
        else if (isprint(c)) break; // ascii
        else c = 0xB7;              // c > ascii -> dot
    }
    debugBytes[i] = c;
  }
  
  NSString *s = [[NSString alloc] initWithBytesNoCopy:debugBytes
                                               length:length
                                             encoding:NSISOLatin1StringEncoding
                                         freeWhenDone:YES];
  if (!s) {
    errFL(@"string encoding failed");
    free(debugBytes);
  }
  return s;
}


- (NSString*)debugDataString {
  return [self debugDataString:(1 << 16)];
}


@end
