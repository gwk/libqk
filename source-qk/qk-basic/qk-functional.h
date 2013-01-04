// Copyright 2012 George King.
// Permission to use this file is granted in libqk/license.txt.


// maps a value to a BOOL. 
typedef BOOL (^BlockFilter)(id);

// maps a value to a value.
typedef id (^BlockMap)(id);

// maps a pair of values to a single value.
typedef id (^BlockMapPair)(id, id);

// maps an int to a value.
typedef id (^BlockMapInt)(int);

// takes the current aggregate value and the next value (or pair of values), and returns the new aggregate value.
typedef id (^BlockReduce)(id, id);
typedef id (^BlockReducePair)(id, id, id);

// takes a mutable aggregate value and the next value (from a collection), and mutates the aggregate.
typedef void (^BlockMutableReduce)(id, id);
typedef void (^BlockMutableReducePair)(id, id, id);

// take a value and return an index (for comparison).
typedef int (^BlockIndex)(id);

// perform an operation on a value
typedef void (^BlockDo)(id);
