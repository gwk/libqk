// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


extern NSString* const QKErrorDomain;

typedef enum {
  // generic
  QKErrorCodeUnknown = 0,
  QKErrorCodeNilPath,
  
  // json
  QKErrorCodeJsonUnexpectedRootType,
  
  // image
  QKErrorCodeImageUnrecognizedPathExtension,
  // PNG
  QKErrorCodeImagePNGOpenFile,
  QKErrorCodeImagePNGSignature,
  QKErrorCodeImagePNGRead,
  QKErrorCodeImagePNGRowsLength,
  
  // JPG
  QKErrorCodeImageJPGReadHeader,
  QKErrorCodeImageJPGDecompress,

} QKErrorCode;


