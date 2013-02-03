// Copyright 2008 George King.
// Permission to use this file is granted in libqk/license.txt.

// General purpose utility macros.


#define loop while (1)
#define for_imns(i, m, n, s) for (Int i = (m), _##i##_end = (n), _##i##_step = (s); i < _##i##_end; i += _##i##_step)
#define for_imn(i, m, n) for_imns(i, (m), (n), 1)
#define for_in(i, n) for_imns(i, 0, (n), 1)


// used to create switch statements that return strings for enum names.
#define CASE_RET_TOK_STR(t) case t: return @#t
#define CASE_RET_TOK_UTF8(t) case t: return #t
#define CASE_RET_TOK_SPLIT_STR(prefix, t) case prefix##t: return @#t
#define CASE_RET_TOK_SPLIT_UTF8(prefix, t) case prefix##t: return #t


// clamp a value to low and high bounds
#define clamp(x, a, b) ({ \
__typeof__(x) __x = (x); \
__typeof__(a) __a = (a); \
__typeof__(b) __b = (b); \
__x < __a ? __a : (__x > __b ? MAX(__a, __b) : __x); })


#define compare(a, b) ({ \
__typeof__(a) __a = (a); \
__typeof__(b) __b = (b); \
__a == __b ? NSOrderedSame : (__a < __b ? NSOrderedAscending : NSOrderedDescending); \
})

#define compare_ret_diff(c, a, b) c = compare(a, b); if (c != NSOrderedSame) return c;



// get a true binary value from an expression
#define bit(x) ((x) ? 1 : 0)

#define bit_xor(a, b) (bit(a) ^ bit(b))


#define LAZY_STATIC(type, name, ...) \
static type name; \
if (!name) { name = (__VA_ARGS__); }

#define LAZY_STATIC_FN(type, name, ...) \
type name() { \
LAZY_STATIC(type, name, __VA_ARGS__); \
return name; \
}


#ifdef __OBJC__


// get a "Y" or "N" string from the boolean value of an expression
#define bit_YN(x) ((x) ? @"Y" : @"N")


// shorthand for the cocoa init idiom
#define INIT(...) if (!((self = ([__VA_ARGS__])))) return nil


// shorthand for checking class membership and protocol conformation

#define IS_KIND(obj, class_name) [(obj) isKindOfClass:[class_name class]]

#define IS_KIND_OR_NIL(obj, class_name) \
({ id _obj = (obj); (!_obj || IS_KIND(_obj, class_name)); })

#define CONFORMS(obj, protocol_name) [(obj) conformsToProtocol:@protocol(protocol_name)]

#define CONFORMS_OR_NIL(obj, protocol_name) \
({ id _obj = (obj); (!_obj || CONFORMS(_obj, protocol_name)); })


// check if an object is nil or NSNull
#define IS_NIL_OR_NULL(obj) \
({ id _obj = (obj); !_obj || IS_KIND(_obj, NSNull); })


// return the object if it is of the specified class, or else nil
#define KIND_OR_NIL(obj, class_name) \
({ class_name* _obj = (id)(obj); (IS_KIND((_obj), class_name) ? (_obj) : nil); })


// return the object if it is of the specified class, or else NSNull
// this is useful for specifying values for dictionaryWithObjectsForKeys:
#define KIND_OR_NULL(obj, class_name) \
({ id _obj = (obj); (IS_KIND((_obj), class_name) ? (_obj) : [NSNull null]); })


#define OBJ_OR_NULL(obj) ({ id _obj = (obj); _obj ? _obj : [NSNull null]; })

// checks


// type checks

#define CHECK_KIND(obj, class_name) \
check(IS_KIND((obj), class_name), \
@"object is not of class: %@; actual: %@", [class_name class], [(obj) class])

#define CHECK_KIND_OR_NIL(obj, class_name) \
check(IS_KIND_OR_NIL((obj), class_name), \
@"non-nil object is not of class: %@; actual: %@", [class_name class], [(obj) class])


#define CHECK_CONFORMS(obj, protocol_name) \
check(CONFORMS((obj), protocol_name), \
@"object does not conform: %s; class: %@", #protocol_name, [(obj) class])

#define CHECK_CONFORMS_OR_NIL(obj, protocol_name) \
check(CONFORMS_OR_NIL((obj), protocol_name), \
@"non-nil object does not conform: %s; class: %@", #protocol_name, [(obj) class])



#if QK_OPTIMIZE
# define ASSERT_KIND(obj, class_name) ((void)0)
# define ASSERT_KIND_OR_NIL(obj, class_name) ((void)0)
# define ASSERT_CONFORMS(obj, protocol_name) ((void)0)
# define ASSERT_CONFORMS_OR_NIL(obj, protocol_name) ((void)0)
#else
# define ASSERT_KIND(obj, class_name) CHECK_KIND((obj), class_name)
# define ASSERT_KIND_OR_NIL(obj, class_name) CHECK_KIND_OR_NIL((obj), class_name)
# define ASSERT_CONFORMS(obj, protocol_name) CHECK_CONFORMS((obj), protocol_name)
# define ASSERT_CONFORMS_OR_NIL(obj, protocol_name) CHECK_CONFORMS_OR_NIL((obj), protocol_name)
#endif


// cast with a run-time type kind assertion
#define CAST(class_name, ...) \
({ id _cast_obj = (__VA_ARGS__); ASSERT_KIND_OR_NIL(_cast_obj, class_name); (class_name*)_cast_obj; })

#define CAST_PROTO(protocol_name, ...) \
({ id _cast_obj = (__VA_ARGS__); ASSERT_CONFORMS_OR_NIL(_cast_obj, protocol_name); (id<protocol_name>)_cast_obj; })


// return the object if it is non-nil, else return the alternate
#define LIVE_ELSE(obj, alternate) \
({ id _obj = (obj); _obj ? _obj : (alternate); })


// inheritence

// shorthand to throw an exception in abstract base methods.
#define OVERRIDE fail(@"must override in subclass or intermediate: %@", [self class])


// throw an exception for non-designated initialization paths:
// place this macro in the implementation of a subclass method
// that is implemented by superclass but should never get called.
#define NON_DESIGNATED_INIT(designated_name) \
[NSException raise:NSInternalInconsistencyException format:@"%s: non-designated initializer: instead use %@", __FUNCTION__, designated_name]; \
return nil


// properties


#define PROPERTY_ALIAS(type, name, Name, path) \
- (type)name { return path; } \
- (void)set##Name:(type)name { path = name; } \


#define PROPERTY_STRUCT_FIELD(type, name, Name, structType, structPath, fieldPath) \
- (type)name { return structPath.fieldPath; } \
- (void)set##Name:(type)name { structType temp = structPath; temp.fieldPath = name; structPath = temp; } \


// threads

#define CHECK_MAIN_THREAD check([NSThread isMainThread], @"requires main thread")
#define ASSERT_MAIN_THREAD assert([NSThread isMainThread], @"requires main thread")

#define CHECK_NOT_MAIN_THREAD check(![NSThread isMainThread], @"requires background thread")
#define ASSERT_NOT_MAIN_THREAD assert(![NSThread isMainThread], @"requires background thread")

#define THREAD_SLEEP(interval) { \
NSTimeInterval _sleep_interval = (interval); \
errFL(@"THREAD_SLEEP: %f", _sleep_interval); \
[NSThread sleepForTimeInterval:_sleep_interval]; \
}


// blocks

// catch clause for non-critical try blocks, where we want to ignore failure
#define CATCH_AND_LOG @catch (id exception) { errFL(@"CAUGHT EXCEPTION: %s\n\%@", __FUNCTION__, exception); }

// declare a temporary qualified version of a variable
#define BLOCK_VAR(temp,     var) __block                __typeof__(var) temp = var
#define WEAK_VAR(temp,      var) __weak                 __typeof__(var) temp = var
#define UNSAFE_VAR(temp,    var) __unsafe_unretained    __typeof__(var) temp = var

#define BLOCK(var)  BLOCK_VAR(block_ ## var,    var)
#define WEAK(var)   WEAK_VAR(weak_ ## var,      var)
#define UNSAFE(var) UNSAFE_VAR(unsafe_ ## var,  var)


// miscellaneous cocoa utilities

#define NSRangeMake NSMakeRange

#define NSRangeTo(to) NSRangeMake(0, (to))

#define NSRangeLength(obj)  NSRangeTo([(obj) length])
#define NSRangeCount(obj)   NSRangeTo([(obj) count])


#define LAZY_CLASS_METHOD(type, name, ...) \
+ (type)name { \
LAZY_STATIC(type, name, __VA_ARGS__); \
return name; \
}

#endif // __OBJC__


// cocoa attributes (for analyzer and ARC)

// several are defined in NSObjCRuntime.h
// NS_RETURNS_RETAINED
// NS_RETURNS_NOT_RETAINED
// NS_REPLACES_RECEIVER
// NS_RELEASES_ARGUMENT - ns_consumed
// NS_VALID_UNTIL_END_OF_SCOPE
// NS_ROOT_CLASS
// NS_RETURNS_INNER_POINTER

// CF_RELEASES_ARGUMENT - cf_consumed

// suppress compiler warnings.
#define UNUSED_FN __attribute__((unused))

// never returns
#define NORETURN __attribute__((noreturn))


// suppress unused var warnings
#define QK_STRINGIFY(x) #x
#define UNUSED_VAR(x) _Pragma(QK_STRINGIFY(unused(x)))



#ifdef __cplusplus

# define FOR_I(container_type, itor_name, container) \
for (container_type::iterator itor_name = (container).begin(); itor_name != (container).end(); ++itor_name)

# define FOR_CI(container_type, itor_name, container) \
for (container_type::const_iterator itor_name = (container).begin(); itor_name != (container).end(); ++itor_name)


# define FILL(pointer, size, value) std::fill((pointer), (pointer) + (size), (value))

# define SORT(pointer, size) std::sort((pointer), (pointer) + (size))


#endif // __cplusplus
