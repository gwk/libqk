// Copyright 2012 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-types.h"
#import "QKDuo.h"


// perform an action.
typedef void (^BlockAction)();

// return a value.
typedef id (^BlockCompute)();

// perform an operation on a value.
typedef void (^BlockDo)(id);
typedef void (^BlockDoString)(NSString*);
typedef void (^BlockDoData)(NSData*);
typedef void (^BlockDoBool)(BOOL);
typedef void (^BlockCompletion)(BOOL);
typedef void (^BlockFinish)(NSError*);

// map a value to a BOOL.
typedef BOOL (^BlockFilter)(id);

// map a value to a value.
typedef id (^BlockMap)(id);

// map a pair of values to a single value.
typedef id (^BlockMapPair)(id, id); // e.g. key, val

// map an int to a value.
typedef id (^BlockMapInt)(Int);

// map a value and int to a value.
typedef id (^BlockMapObjInt)(id, Int); // e.g. value, index

// map a value to a pair of values.
typedef QKDuo* (^BlockMapToPair)(id);

// take the current aggregate value and the next value, and return the new aggregate value.
typedef id (^BlockReduce)(id, id); // agg, val
typedef id (^BlockReducePair)(id, id, id); // e.g. agg, key, val

// take a mutable aggregate value and the next value, and mutate the aggregate.
typedef void (^BlockMutableReduce)(id, id); // mutable_result, val
typedef void (^BlockMutableReducePair)(id, id, id); // e.g. mutable_result, key, vanl

// take a value and return an index.
typedef Int (^BlockMaptoInt)(id);
typedef F64 (^BlockMapToF64)(id);

typedef Int (^BlockReduceToInt)(Int, id); // agg, val
typedef F32 (^BlockReduceToF32)(F32, id); // agg, val
typedef F64 (^BlockReduceToF64)(F64, id); // agg, val
