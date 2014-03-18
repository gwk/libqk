// Copyright 2009 George King.
// Permission to use this file is granted in libqk-license.txt (ISC License).


#if QK_SILENCE_ERR
# define err_item(...) ((void)0)
# define err_items(...) ((void)0)
#else
# define err_item(...) qk_err_item(__VA_ARGS__)
# define err_items(...) qk_err_items(__VA_ARGS__)
#endif


#define eprintf(...) fprintf(stderr, __VA_ARGS__)

// would name err_ as err but it would collide with other things.
#define err_(...)   err_items(@[__VA_ARGS__], @"", nil)
#define errS(...)   err_items(@[__VA_ARGS__], @" ", nil)
#define errL(...)   err_items(@[__VA_ARGS__], @"", @"\n")
#define errSL(...)  err_items(@[__VA_ARGS__], @" ", @"\n")
#define errLL(...)  err_items(@[__VA_ARGS__], @"\n", @"\n")

#define errF(...)  err_item([NSString stringWithFormat:__VA_ARGS__], @"")
#define errFL(...) err_item([NSString stringWithFormat:__VA_ARGS__], @"\n")

// logging shorthand

#define LOG(x)          errFL(@"%s: %@", #x, (x))
#define LOGS(x)         errFL(@"%s: %s", #x, (x))
#define LOGP(x)         errFL(@"%s: %p", #x, (x))
#define LOGD(x)         errFL(@"%s: %d", #x, (x))
#define LOGL(x)         errFL(@"%s: %ld", #x, (x))
#define LOGF(x)         errFL(@"%s: %f", #x, (x))
#define LOGB(x)         errFL(@"%s: %@", #x, (x) ? @"YES" : @"NO")

#define LOG_RANGE(x)    errFL(@"%s: %@", #x, NSStringFromRange(x))

#if TARGET_OS_IPHONE
#define LOG_EI(x)       errFL(@"%s: %@", #x, NSStringFromUIEdgeInsets(x))
#else
#define NSStringFromCGPoint NSStringFromPoint
#define NSStringFromCGSize  NSStringFromSize
#define NSStringFromCGRect  NSStringFromRect
#endif

#define LOG_POINT(x)    errFL(@"%s: %@", #x, NSStringFromCGPoint(x))
#define LOG_SIZE(x)     errFL(@"%s: %@", #x, NSStringFromCGSize(x))
#define LOG_RECT(x)     errFL(@"%s: %@", #x, NSStringFromCGRect(x))
#define LOG_AT(x)       errFL(@"%s: %@", #x, NSStringFromCGAffineTransform(x))
#define LOG_CENTER(x)   errFL(@"%s center: %@", #x, (x) ? NSStringFromCGPoint((x).center) : @"(null object)")
#define LOG_TRANSFORM(x) errFL(@"%s transform: %@", #x, (x) ? NSStringFromCGAffineTransform((x).transform) : @"(null object)")

#define LOG_OBJ_SIZE(x) errFL(@"%s size: %@",   #x, (x) ? NSStringFromCGSize((x).size) : @"(null object)")
#define LOG_FRAME(x)    errFL(@"%s frame: %@",  #x, (x) ? NSStringFromCGRect((x).frame) : @"(null object)")
#define LOG_BOUNDS(x)   errFL(@"%s bounds: %@", #x, (x) ? NSStringFromCGRect((x).bounds) : @"(null object)")

#define LOG_(T, x)      errFL(@"%s: %@", #x, T##Desc(x))

// log source positions.
#define LOG_LINE            errFL(@"LOG_LINE: %04d %s", __LINE__, __FILE__)
#define LOG_FN errFL(@"LOG_FN: %s", __FUNCTION__)

#define LOG_METHOD          errFL(@"%p\t(%@)\t%s",          self, [self class], __FUNCTION__)
#define LOG_METHOD1(a1)     errFL(@"%p\t(%@)\t%s %s: %@",   self, [self class], __FUNCTION__, #a1, a1)
#define LOG_METHOD1B(b1)    errFL(@"%p\t(%@)\t%s %s: %@",   self, [self class], __FUNCTION__, #b1, (b1 ? @"YES" : @"NO"))
#define LOG_METHOD1D(d1)    errFL(@"%p\t(%@)\t%s %s: %d",   self, [self class], __FUNCTION__, #d1, d1)
#define LOG_METHOD1LD(d1)    errFL(@"%p\t(%@)\t%s %s: %ld", self, [self class], __FUNCTION__, #d1, d1)
#define LOG_METHOD1F(f1)    errFL(@"%p\t(%@)\t%s %s: %f",   self, [self class], __FUNCTION__, #f1, f1)

#define LOG_ERROR(e) errFL(@"%p\t%@\t%s: error: %@", self, [self class], __FUNCTION__, e)

#define LOG_TIME_INTERVAL(start, ...) { \
UNUSED_VAR(start); \
errFL(@"time interval: %s: %s: %f; " __VA_ARGS__, __PRETTY_FUNCTION__, #start, [NSDate refTime] - (start)); \
} \


// log the contents of an array by mapping each value using the variadic macro
// for example: LOG_ARRAY(array, v, [NSString stringWithFormat:@"%p -> %@", v, v])
// will print strings showing the pointers and descriptions of each element
#define LOG_ARRAY_MAP(array, var, ...) \
errFL(@"%s: %@", #array, [array map:^id(id var) { return __VA_ARGS__; }])


// log a Python object.
#define LOGPY(x) { fprintf(stderr, "%s: ", #x); PyObject_Print((x), stderr, 0); fputc('\n', stderr); }


void qk_err_item(NSString* item, NSString* end);
void qk_err_items(NSArray* items, NSString* sep, NSString* end);

