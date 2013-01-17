// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-types.h"
#import "Duo.h"


// perform an operation on a value
typedef void (^BlockDo)(id);

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
typedef Duo* (^BlockMapToPair)(id);

// take the current aggregate value and the next value, and return the new aggregate value.
typedef id (^BlockReduce)(id, id); // agg, val
typedef id (^BlockReducePair)(id, id, id); // e.g. agg, key, val

// take a mutable aggregate value and the next value, and mutate the aggregate.
typedef void (^BlockMutableReduce)(id, id); // mutable_result, val
typedef void (^BlockMutableReducePair)(id, id, id); // e.g. mutable_result, key, vanl

// take a value and return an index.
typedef Int (^BlockMaptoInt)(id);

typedef Int(^BlockReduceToInt)(Int, id); // agg, val
