// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


// JNB is a file format consisting of:
// - a UTF-8 JSON header
// - zero or more null terminator bytes (if none then the file is pure JSON).
// - optional binary data beginning on the next 16-byte-aligned offset after the first null terminator.

// serialized data type string that specifies this item can loaded polymorphically.
static NSString* const JNBTypeKey = @"jnb-type";

extern NSString* const JNBErrorDomain;

typedef enum {
  JNBErrorCodeUnknown             = 0,
  JNBErrorCodeTypeMissing         = 1,    // "type" item is missing from header.
  JNBErrorCodeTypeUnkown          = 2,     // "type" item has bad value.
  JNBErrorCodeTypeUnexpected      = 3, // type is valid, but does not match calling class.
  JNBErrorCodeKeyMissing          = 4,     // key is required but missing.
  JNBErrorCodeValTypeUnexpected   = 5,  // value is of unexpected type.
  JNBErrorCodeValInvalid          = 6,         // value is invalid.
  JNBErrorCodeValTransformFailed  = 7, // transform returned an error.
  JNBErrorCodeDataMalformed       = 8, // data region is not properly offset.
  JNBErrorCodeDataMissing         = 9,  // intended to be returned by decoder blocks that require non-nil data.
} JNBErrorCode;


@interface NSObject (JNB)

// generic decoding is accomplished by overriding these methods:
+ (NSDictionary*)jnbValTypes; // maps header keys to expected value classes.

// maps header keys to optional value transform blocks. blocks may signal an error by returning an NSError.
// subclasses should override these to provide BlockMap blocks for keys that require additional handling.
+ (NSDictionary*)jnbValDecoders;
+ (NSDictionary*)jnbValEncoders;

// optional method for handling data section.
- (NSError*)jnbDataDecode:(QKSubData*)data;
- (NSError*)jnbDataEncode:(NSOutputStream*)stream;

// JNB-serialized classes may also override these methods to implement custom coding.
- (NSError*)updateWithJnbDict:(NSDictionary*)dict data:(QKSubData*)data;
- (NSError*)jnbEncode:(NSOutputStream*)stream;

- (id)initWithJnbDict:(NSDictionary*)dict data:(QKSubData*)data error:(NSError**)errorPtr;
+ (id)withJnbPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (id)jnbNamed:(NSString*)resourceName;

- (NSError*)writeJnbToPath:(NSString*)path;

@end

