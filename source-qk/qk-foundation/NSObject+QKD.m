// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSObject+QKD.h"


@implementation NSObject (QKD)


+ (NSDictionary*)qkdValTypes {
  OVERRIDE;
}


+ (NSDictionary*)qkdValDecoders {
  return nil; 
}


+ (NSDictionary*)qkdValEncoders {
  return nil;
}


- (NSError*)qkdDataDecode:(QKSubData*)data {
  return nil;
}


- (NSError*)qkdDataEncode:(NSOutputStream*)stream {
  return nil;
}


- (NSError*)updateWithQkdDict:(NSDictionary*)dict data:(QKSubData*)data {
  NSDictionary* valTypes = [self.class qkdValTypes];
  NSDictionary* valDecoders = [self.class qkdValDecoders];
  for (NSString* key in valTypes.allKeys) {
    id val = [dict objectForKey:key];
    if (!val) {
      return [NSError withDomain:QKDErrorDomain code:QKDErrorCodeKeyMissing desc:@"missing key" info:@{
              @"dict" : dict,
              @"class" : self.class,
              @"key" : key,
              }];
    }
    Class expectedClass = [valTypes objectForKey:key];
    assert(expectedClass, @"qkdValTypes dictionary is missing key: %@", key);
    if (![val isKindOfClass:expectedClass]) {
      return [NSError withDomain:QKDErrorDomain code:QKDErrorCodeValTypeUnexpected desc:@"bad value type" info:@{
              @"dict" : dict,
              @"class" : self.class,
              @"key" : key,
              @"val" : val,
              @"val-type-expected" : expectedClass,
              @"val-type-actual" : [val class],
              }];
    }
    BlockMap mapBlock = [valDecoders objectForKey:key];
    if (mapBlock) {
      id val_transformed = mapBlock(val);
      if (IS_KIND(val_transformed, NSError)) {
        return [NSError withDomain:QKDErrorDomain
                              code:QKDErrorCodeValTransformFailed
                              desc:@"value transform failed"
                              info:@{
                @"dict" : dict,
                @"class" : self.class,
                @"key" : key,
                @"val" : val,
             NSUnderlyingErrorKey : val_transformed
                }];
      }
      val = val_transformed;
    }
    [self setValue:val forKey:key];
  }
  return [self qkdDataDecode:data];
}


- (NSError*)qkdEncode:(NSOutputStream*)stream {
  NSDictionary* valTypes = [self.class qkdValTypes];
  NSDictionary* valEncoders = [self.class qkdValEncoders];
  NSDictionary* dict = [valTypes.allKeys mapToDict:^(NSString* key){
    id val = [self valueForKey:key];
    BlockMap mapBlock = [valEncoders objectForKey:key];
    if (mapBlock) {
      val = mapBlock(val);
    }
    assert([val isKindOfClass:[valTypes objectForKey:key]], @"bad value type: %@; %@", [val class], val);
    return [Duo a:key b:val];
  }];
  NSError* e = nil;
  Int written = [NSJSONSerialization writeJSONObject:dict toStream:stream options:0 error:&e];
  if (e) {
    return e;
  }
  Int data_offset = (written + 0x10) & ~(size_t)0x0F;
  Int pad_length = data_offset - written;
  assert(pad_length > 0, @"bad pad length: %ld", pad_length);
  U8 pad[pad_length];
  memset(pad, 0, pad_length);
  Int pad_written = [stream write:pad maxLength:pad_length];
  if (pad_written < 0) {
    return stream.streamError;
  }
  return [self qkdDataEncode:stream];
}



- (id)initWithQkdDict:(NSDictionary*)dict data:(QKSubData*)data error:(NSError**)errorPtr {
  INIT(self init);
  *errorPtr = [self updateWithQkdDict:dict data:data];
  return *errorPtr ? nil : self;
}


+ (id)withQkdPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr {
#define ERROR(_code, _desc, ...) \
*errorPtr = [NSError withDomain:QKDErrorDomain code:_code desc:_desc info:@{ @"path" : path, ##__VA_ARGS__ }]; \
return nil;
  
  LAZY_STATIC(NSDictionary*, typesToClasses, @{
              @"image" : [QKImage class],
              });
  
  NSData* data = [NSData withPath:path map:map error:errorPtr];
  if (*errorPtr) {
    return nil;
  }
  const void* bytes = data.bytes;
  Int length = data.length;
  Int offset_header_terminator = strnlen(bytes, length);
  
  NSData* jsonData = (offset_header_terminator < length)
  ? [data subdataWithRange:NSRangeMake(0, offset_header_terminator)]
  : data; // no null terminator or data section
  
  NSDictionary* dict = [jsonData dictFromJsonWithError:errorPtr];
  if (*errorPtr) {
    return nil;
  }
  assert(dict, @"nil dict");
  
  NSString* typeName = [dict objectForKey:QKDTypeKey];
  Class targetClass;
  if (typeName) {
    targetClass = [typesToClasses objectForKey:typeName];
    if (!targetClass) {
      ERROR(QKDErrorCodeTypeUnkown, @"QKD header specifies unknown type",
            @"dict" : dict,
            @"type" : typeName,
            );
    }
    if (![targetClass isSubclassOfClass:self]) {
      ERROR(QKDErrorCodeTypeUnexpected, @"QKD header specifies unexpected type",
            @"dict" : dict,
            @"type" : typeName,
            @"calling-class" : self,
            @"target-class" : targetClass
            );
    }
  }
  else {
    targetClass = self;
  }
  
  QKSubData* subdata;
  if (offset_header_terminator < length) { // found a null terminator
    // data begins at the next 16-byte-aligned address after the header terminator.
    // conceptually we want to add 1, then 15, then mask out the low 4 bits.
    Int data_offset = (offset_header_terminator + 0x10) & ~(size_t)0x0F;
    Int data_length = length - data_offset;
    if (data_offset >= length) {
      ERROR(QKDErrorCodeDataMalformed, @"QKD is missing 16-byte-aligned data region");
    }
    subdata = [QKSubData withData:data offset:data_offset length:data_length];
  }
  else {
    subdata = nil;
  }
  return [[targetClass alloc] initWithQkdDict:dict data:subdata error:errorPtr];
#undef ERROR
}


+ (id)qkdNamed:(NSString*)resourceName {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  NSError* e = nil;
  id obj = [self withQkdPath:path map:YES error:&e];
  assert(!e, @"error loading qkd resource: %@; %@", resourceName, e);
  return obj;
}


- (NSError*)qkdWriteToPath:(NSString*)path {
  NSOutputStream* s = [NSOutputStream outputStreamToFileAtPath:path append:NO];
  assert(s, @"nil stream (this should return error)");
  [s open];
  NSError* e = [self qkdEncode:s];
  [s close];
  return e;
}


@end

