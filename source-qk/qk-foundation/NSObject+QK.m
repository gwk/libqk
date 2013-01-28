// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "QKImage.h"
#import "NSObject+QK.h"


NSString* const QKDErrorDomain = @"QKDErrorDomain";


void  executeAsync(BlockExecute asyncBlock, BlockDo syncBlock) {
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    id result;
    @try {
      result = asyncBlock();
    }
    @catch (NSException* e) {
      dispatch_async(dispatch_get_main_queue(), ^{
        errFL(@"exception during executeAsync: %@\n%@", e, e.callStackSymbols);
        [e raise];
      });
      return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      syncBlock(result);
    });
  });
}


@implementation NSObject (Oro)


- (void)dissolve {}


// participating classes must override this.
- (id)initWithHeader:(NSDictionary*)header data:(QKSubData*)data error:(NSError**)errorPtr {
  OVERRIDE;
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
  Int offset_header_terminator = strnlen(bytes, data.length);
  if (offset_header_terminator >= length) {
    ERROR(QKDErrorCodeDataMissing, @"QKD is missing header null terminator");
  }
  // data begins at the next 16-byte-aligned address after the header terminator.
  // conceptually we want to add 1, then 15, then mask out the low 4 bits.
  Int data_offset = (offset_header_terminator + 0x10) & ~(size_t)0x0F;
  Int data_length = length - data_offset;
  if (data_offset >= length) {
    ERROR(QKDErrorCodeDataMissing, @"QKD is missing 16-byte-aligned data region");
  }
  NSData* headerData = [data subdataWithRange:NSRangeMake(0, offset_header_terminator)];
  NSDictionary* header = [headerData dictFromJsonWithError:errorPtr];
  if (*errorPtr) {
    return nil;
  }
  assert(header, @"nil header");
  
  NSString* typeName = [header objectForKey:@"type"];
  if (!typeName) {
    ERROR(QKDErrorCodeTypeMissing, @"QKD header is missing type", @"header" : header);
  }
  
  Class c = [typesToClasses objectForKey:typeName];
  if (!c) {
    ERROR(QKDErrorCodeTypeUnkown, @"QKD header specifies unknown type",
          @"header" : header,
          @"type" : typeName,
          );
  }
  if (c != self && ![c isSubclassOfClass:self]) {
    ERROR(QKDErrorCodeTypeUnexpected, @"QKD header specifies unexpected type",
          @"header" : header,
          @"type" : typeName,
          @"class" : self,
          );
  }
  QKSubData* subdata = [QKSubData withData:data offset:data_offset length:data_length mapped:map];
  return [[c alloc] initWithHeader:header data:subdata error:errorPtr];
#undef ERROR
}


+ (id)withQkdNamed:(NSString*)resourceName {
  NSString* path = [NSBundle resPath:resourceName ofType:nil];
  NSError* e = nil;
  id obj = [self withQkdPath:path map:YES error:&e];
  assert(!e, @"error loading qkd resource: %@; %@", resourceName, e);
  return obj;
}


@end
