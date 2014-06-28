// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.

#import "QKData.h"


// JNB is a file format consisting of:
// - a UTF-8 JSON header
// - zero or more null terminator bytes (if none then the file is pure JSON).
// - optional binary data beginning on the next 16-byte-aligned offset after the first null terminator.

// serialized data type string that specifies this item can loaded polymorphically.
static NSString* const JNBTypeKey = @"jnb-type";

extern NSString* const JNBErrorDomain;

typedef enum {
  JNBErrorCodeUnknown,
  JNBErrorCodeTypeMissing,        // "jnb-type" item is missing from header.
  JNBErrorCodeTypeUnkown,         // "jnb-type" item has bad value.
  JNBErrorCodeTypeUnexpected,     // type is valid, but does not match calling class.
  JNBErrorCodeKeyMissing,         // key is required but missing.
  JNBErrorCodeValTypeUnexpected,  // value is of unexpected type.
  JNBErrorCodeValInvalid,         // value is invalid.
  JNBErrorCodeValTransformFailed, // transform returned an error.
  JNBErrorCodeDataMalformed,      // data region is not properly offset.
  JNBErrorCodeDataMissing,        // intended to be returned by decoder blocks that require non-nil data.
} JNBErrorCode;


@interface NSObject (JNB)

// generic decoding is accomplished by overriding these methods:
+ (NSDictionary*)jnbValTypes; // maps header keys to expected value classes.

// maps header keys to optional value transform blocks. blocks may signal an error by returning an NSError.
// subclasses should override these to provide BlockMap blocks for keys that require additional handling.
+ (NSDictionary*)jnbValDecoders;
+ (NSDictionary*)jnbValEncoders;

// optional method for handling data section.
- (NSError*)jnbDataDecode:(id<QKData>)data;
- (NSError*)jnbDataEncode:(NSOutputStream*)stream;

// JNB-serialized classes may also override these methods to implement custom coding.
- (NSError*)updateWithJnbDict:(NSDictionary*)dict data:(id<QKData>)data;
- (NSError*)jnbEncode:(NSOutputStream*)stream;

- (id)initWithJnbDict:(NSDictionary*)dict data:(id<QKData>)data error:(NSError**)errorPtr;
+ (id)withJnbPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (id)jnbNamed:(NSString*)resourceName;

- (NSObject*)readJnbFromPath:(NSString*)path;
- (NSError*)writeJnbToPath:(NSString*)path;

@end

