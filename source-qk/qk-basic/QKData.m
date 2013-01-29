// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKData.h"


@implementation NSObject (QKData)


- (NSString *)debugDataString:(Int)limit {
  id<QKData> data = CAST_PROTO(QKData, self);
  
  NSUInteger length = MIN(data.length, limit);
  const char* bytes = data.bytes;
  char* debugBytes = malloc(length);
  
  // convert problematic characters to readable characters in iso latin 1
  for (int i = 0; i < length; i++) {
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
