// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "qk-block-types.h"
#import "NSArray+QK.h"
#import "NSBundle+QK.h"
#import "NSData+QK.h"
#import "NSObject+JNB.h"
#import "QKSubData.h"
#import "QKImage.h"


NSString* const JNBErrorDomain = @"JNBErrorDomain";


@implementation NSObject (JNB)


+ (NSDictionary*)jnbValTypes {
  MUST_OVERRIDE;
}


+ (NSDictionary*)jnbValDecoders {
  return nil;
}


+ (NSDictionary*)jnbValEncoders {
  return nil;
}


- (NSError*)jnbDataDecode:(id<QKData>)data {
  return nil;
}


- (NSError*)jnbDataEncode:(NSOutputStream*)stream {
  return nil;
}


- (NSError*)updateWithJnbDict:(NSDictionary*)dict data:(id<QKData>)data {
  NSDictionary* valTypes = [self.class jnbValTypes];
  NSDictionary* valDecoders = [self.class jnbValDecoders];
  for (NSString* key in valTypes.allKeys) {
    id val = [dict objectForKey:key];
    CHECK_RET_ERROR(val, JNB, KeyMissing, @"missing key", @{
                    @"dict" : dict,
                    @"class" : self.class,
                    @"key" : key,
                    });
    
    Class expectedClass = [valTypes objectForKey:key];
    qk_assert(expectedClass, @"jnbValTypes dictionary is missing key: %@", key);
    CHECK_RET_ERROR([val isKindOfClass:expectedClass], JNB, ValTypeUnexpected, @"bad value type",
                    @{
                    @"dict" : dict,
                    @"class" : self.class,
                    @"key" : key,
                    @"val" : val,
                    @"val-type-expected" : expectedClass,
                    @"val-type-actual" : [val class],
                    });
    
    BlockMap mapBlock = [valDecoders objectForKey:key];
    if (mapBlock) {
      id val_transformed = mapBlock(val);
      CHECK_RET_ERROR(!IS_KIND(val_transformed, NSError), JNB, ValTransformFailed, @"value transform failed", @{
                      @"dict" : dict,
                      @"class" : self.class,
                      @"key" : key,
                      @"val" : val,
                      NSUnderlyingErrorKey : val_transformed
                      });
      val = val_transformed;
    }
    [self setValue:val forKey:key];
  }
  return [self jnbDataDecode:data];
}


- (NSError*)jnbEncode:(NSOutputStream*)stream {
  NSDictionary* valTypes = [self.class jnbValTypes];
  NSDictionary* valEncoders = [self.class jnbValEncoders];
  NSDictionary* dict = [valTypes.allKeys mapToDict:^(NSString* key){
    id val = [self valueForKey:key];
    BlockMap mapBlock = [valEncoders objectForKey:key];
    if (mapBlock) {
      val = mapBlock(val);
    }
    qk_assert([val isKindOfClass:[valTypes objectForKey:key]], @"bad value type: %@; %@", [val class], val);
    return [Duo a:key b:val];
  }];
  NSError* e = nil;
  Int written = [NSJSONSerialization writeJSONObject:dict toStream:stream options:0 error:&e];
  if (e) {
    return e;
  }
  Int data_offset = (written + 0x10) & ~(size_t)0x0F;
  Int pad_length = data_offset - written;
  qk_assert(pad_length > 0, @"bad pad length: %ld", pad_length);
  U8 pad[pad_length];
  memset(pad, 0, pad_length);
  Int pad_written = [stream write:pad maxLength:pad_length];
  if (pad_written < 0) {
    return stream.streamError;
  }
  return [self jnbDataEncode:stream];
}



- (id)initWithJnbDict:(NSDictionary*)dict data:(id<QKData>)data error:(NSError**)errorPtr {
  INIT(self init);
  NSError* e = [self updateWithJnbDict:dict data:data];
  if (errorPtr) {
    *errorPtr = e;
  }
  return e ? nil : self;
}


+ (id)withJnbPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr {
  LAZY_STATIC(NSDictionary*, typesToClasses, @{
              @"path" : path,
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
  qk_assert(dict, @"nil dict");
  
  NSString* typeName = [dict objectForKey:JNBTypeKey];
  Class targetClass;
  if (typeName) {
    targetClass = [typesToClasses objectForKey:typeName];
    CHECK_SET_ERROR_RET_NIL(targetClass, JNB, TypeUnkown, @"JNB header specifies unknown type", @{
                            @"path" : path,
                            @"dict" : dict,
                            @"type" : typeName,
                            });
    CHECK_SET_ERROR_RET_NIL([targetClass isSubclassOfClass:self], JNB, TypeUnexpected,
                            @"JNB header specifies unexpected type", @{
                            @"path" : path,
                            @"dict" : dict,
                            @"type" : typeName,
                            @"calling-class" : self,
                            @"target-class" : targetClass
                            });
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
    CHECK_SET_ERROR_RET_NIL(data_offset < length, JNB, DataMalformed, @"JNB is missing 16-byte-aligned data region", @{
                            @"path" : path
                            });
    subdata = [QKSubData withData:data offset:data_offset length:data_length];
  }
  else {
    subdata = nil;
  }
  return [[targetClass alloc] initWithJnbDict:dict data:subdata error:errorPtr];
#undef ERROR
}


+ (id)jnbNamed:(NSString*)resourceName {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  NSError* e = nil;
  id obj = [self withJnbPath:path map:YES error:&e];
  qk_assert(!e, @"error loading JNB resource: %@; %@", resourceName, e);
  return obj;
}


- (NSError*)writeJnbToPath:(NSString*)path {
  NSOutputStream* s = [NSOutputStream outputStreamToFileAtPath:path append:NO];
  if (!s) {
    return [NSError withDomain:NSCocoaErrorDomain
                          code:NSFileWriteInvalidFileNameError
                          desc:@"could not open output stream" info:@{
            @"path" : OBJ_OR_NULL(path)
            }];
  }
  [s open];
  NSError* e = [self jnbEncode:s];
  [s close];
  return e;
}


@end

