// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


// QKD is a file format consisting of:
// - a UTF-8 JSON header
// - zero or more null terminator bytes (if none then the file is pure JSON).
// - optional binary data beginning on the next 16-byte-aligned offset after the first null terminator.

// serialized data that specifies this item can loaded polymorphically.
static NSString* const QKDTypeKey = @"qkd-type";

extern NSString* const QKDErrorDomain;

typedef enum {
  QKDErrorCodeUnknown             = 0,
  QKDErrorCodeTypeMissing         = 1,    // "type" item is missing from header.
  QKDErrorCodeTypeUnkown          = 2,     // "type" item has bad value.
  QKDErrorCodeTypeUnexpected      = 3, // type is valid, but does not match calling class.
  QKDErrorCodeKeyMissing          = 4,     // key is required but missing.
  QKDErrorCodeValTypeUnexpected   = 5,  // value is of unexpected type.
  QKDErrorCodeValInvalid          = 6,         // value is invalid.
  QKDErrorCodeValTransformFailed  = 7, // transform returned an error.
  QKDErrorCodeDataMalformed       = 8, // data region is not properly offset.
  QKDErrorCodeDataMissing         = 9,  // intended to be returned by decoder blocks that require non-nil data.
} QKDErrorCode;


@interface NSObject (QKD)

// generic decoding is accomplished by overriding these methods:
+ (NSDictionary*)qkdValTypes; // maps header keys to expected value classes.

// maps header keys to optional value transform blocks. blocks may signal an error by returning an NSError.
// subclasses should override these to provide BlockMap blocks for keys that require additional handling.
+ (NSDictionary*)qkdValDecoders;
+ (NSDictionary*)qkdValEncoders;

// optional method for handling data section.
- (NSError*)qkdDataDecode:(QKSubData*)data;
- (NSError*)qkdDataEncode:(NSOutputStream*)stream;

// QKD-serialized classes may also override these methods to implement custom coding.
- (NSError*)updateWithQkdDict:(NSDictionary*)dict data:(QKSubData*)data;
- (NSError*)qkdEncode:(NSOutputStream*)stream;

- (id)initWithQkdDict:(NSDictionary*)dict data:(QKSubData*)data error:(NSError**)errorPtr;
+ (id)withQkdPath:(NSString*)path map:(BOOL)map error:(NSError**)errorPtr;
+ (id)qkdNamed:(NSString*)resourceName;

- (NSError*)qkdWriteToPath:(NSString*)path;

@end

