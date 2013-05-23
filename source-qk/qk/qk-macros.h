// Copyright 2008 George King.
// Permission to use this file is granted in libqk/license.txt.

// General purpose utility macros.


#import "qk-types.h"
#import "qk-check.h"
#import "qk-log.h"
#import "NSError+QK.h"


#define loop while (1)
#define for_imns(i, m, n, s) for (Int i = (m), _##i##_end = (n), _##i##_step = (s); i < _##i##_end; i += _##i##_step)

#define for_imns_rev(i, m, n, s) \
for (Int i = (n) - 1, _##i##_end = (m), _##i##_step = (s); i >= _##i##_end; i -= _##i##_step)

#define for_imn(i, m, n) for_imns(i, (m), (n), 1)
#define for_in(i, n) for_imns(i, 0, (n), 1)

#define for_imn_rev(i, n) for_imns_rev(i, (m), (n), 1)
#define for_in_rev(i, n) for_imns_rev(i, 0, (n), 1)


// used to create switch statements that return strings for enum names.
#define CASE_RET_TOK_STR(t) case t: return @#t
#define CASE_RET_TOK_UTF8(t) case t: return #t
#define CASE_RET_TOK_SPLIT_STR(prefix, t) case prefix##t: return @#t
#define CASE_RET_TOK_SPLIT_UTF8(prefix, t) case prefix##t: return #t

// get a true binary value from an expression
#define BIT(x) ((x) ? 1 : 0)

#define BIT_XOR(a, b) (BIT(a) ^ BIT(b))

#define SIGN(x) ({__typeof__(x) __x = (x); __x > 0 ? 1 : (__x < 0 ? -1 : 0); })

#define SIGN_NORM_01(x) ({__typeof__(x) __x = (x); __x > 0 ? 1.0 : (__x < 0 ? 0.0 : 0.5); })

// clamp a value to low and high bounds
// variables have _clamp suffix so as not to collide with variables inside of MAX.
// note that the low bound takes precedent over the higher bound.
#define CLAMP(x, a, b) ({ \
__typeof__(x) __x_clamp = (x); \
__typeof__(a) __a_clamp = (a); \
__typeof__(b) __b_clamp = MAX(__a_clamp, (b)); \
__x_clamp < __a_clamp ? __a_clamp : (__x_clamp > __b_clamp ? __b_clamp : __x_clamp); })


#define COMPARE(a, b) ({ \
__typeof__(a) __a = (a); \
__typeof__(b) __b = (b); \
__a == __b ? NSOrderedSame : (__a < __b ? NSOrderedAscending : NSOrderedDescending); \
})

#define COMPARE_RET_DIFF(c, a, b) c = COMPARE(a, b); if (c != NSOrderedSame) return c;

#define UPDATE_MAX(var, val) ({ __typeof__(val) __val = (val); if (var < __val) var = __val; })
#define UPDATE_MIN(var, val) ({ __typeof__(val) __val = (val); if (var > __val) var = __val; })
#define LAZY_STATIC(type, name, ...) \
static type name; \
if (!name) { name = (__VA_ARGS__); }

#define LAZY_STATIC_FN(type, name, ...) \
type name() { \
LAZY_STATIC(type, name, __VA_ARGS__); \
return name; \
}


#ifdef __OBJC__


#pragma mark - types


// get a "Y" or "N" string from the boolean value of an expression
#define BIT_YN(x) ((x) ? @"Y" : @"N")


// shorthand for checking class membership and protocol conformation
#define IS_KIND(obj, class_name) [(obj) isKindOfClass:[class_name class]]

#define IS_KIND_OR_NIL(obj, class_name) \
({ id __obj = (obj); (!__obj || IS_KIND(__obj, class_name)); })

#define CONFORMS(obj, protocol_name) [(obj) conformsToProtocol:@protocol(protocol_name)]

#define CONFORMS_OR_NIL(obj, protocol_name) \
({ id __obj = (obj); (!__obj || CONFORMS(__obj, protocol_name)); })


// check if an object is nil or NSNull
#define IS_NIL_OR_NULL(obj) \
({ id __obj = (obj); !__obj || IS_KIND(__obj, NSNull); })


// return the object if it is of the specified class, or else nil
#define KIND_OR_NIL(obj, class_name) \
({ class_name* __obj = (id)(obj); (IS_KIND((__obj), class_name) ? (__obj) : nil); })


// return the object if it is of the specified class, or else NSNull
// this is useful for specifying values for dictionaryWithObjectsForKeys:
#define KIND_OR_NULL(obj, class_name) \
({ id __obj = (obj); (IS_KIND((__obj), class_name) ? (__obj) : [NSNull null]); })


#define OBJ_OR_NULL(obj) ({ id __obj = (obj); __obj ? __obj : [NSNull null]; })


// type checks

#define CHECK_KIND(obj, class_name) \
qk_check(IS_KIND((obj), class_name), \
@"object is not of class: %@; actual: %@", [class_name class], [(obj) class])

#define CHECK_KIND_OR_NIL(obj, class_name) \
qk_check(IS_KIND_OR_NIL((obj), class_name), \
@"non-nil object is not of class: %@; actual: %@", [class_name class], [(obj) class])


#define CHECK_CONFORMS(obj, protocol_name) \
qk_check(CONFORMS((obj), protocol_name), \
@"object does not conform: %s; class: %@", #protocol_name, [(obj) class])

#define CHECK_CONFORMS_OR_NIL(obj, protocol_name) \
qk_check(CONFORMS_OR_NIL((obj), protocol_name), \
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
({ id __cast_obj = (__VA_ARGS__); ASSERT_KIND_OR_NIL(__cast_obj, class_name); (class_name*)__cast_obj; })

#define CAST_PROTO(protocol_name, ...) \
({ id __cast_obj = (__VA_ARGS__); ASSERT_CONFORMS_OR_NIL(__cast_obj, protocol_name); (id<protocol_name>)__cast_obj; })


// return the object if it is non-nil, else return the alternate.
// necessary because ARC forbids a || b syntax with objc pointers.
#define LIVE_ELSE(obj, alternate) \
({ id __obj = (obj); __obj ? __obj : (alternate); })



#pragma mark - reference counting


// retain cycle mitigation
#define DISSOLVE(obj) { [(obj) dissolve]; (obj) = nil; }


#pragma mark - initialization


// shorthand for the cocoa init idiom
#define INIT(...) if (!((self = ([__VA_ARGS__])))) return nil


#define DEC_WITH(...) \
+ (id)with##__VA_ARGS__;

#define DEF_WITH(...) \
+ (id)with##__VA_ARGS__ { return [[self alloc] initWith##__VA_ARGS__]; }


// define + (id)with... and - (id)initWith... simultaneously.
#define DEC_INIT(...) \
+ (id)with##__VA_ARGS__; \
- (id)initWith##__VA_ARGS__

#define DEF_INIT(...) \
DEF_WITH(__VA_ARGS__) \
- (id)initWith##__VA_ARGS__


#pragma mark - properties


#define PROPERTY_ALIAS(type, name, Name, path) \
- (type)name { return path; } \
- (void)set##Name:(type)name { path = name; } \


#define SUB_PROPERTY_ALIAS(type, name, Name, sub) PROPERTY_ALIAS(type, name, Name, sub.name)


#define PROPERTY_SUBCLASS_ALIAS(class_name, name, Name, path) \
- (class_name*)name { return CAST(class_name, path); } \
- (void)set##Name:(class_name*)name { path = name; } \


#define PROPERTY_SUBCLASS_ALIAS_RO(class_name, name, path) \
- (class_name*)name { return CAST(class_name, path); } \


#define PROPERTY_STRUCT_FIELD(type, name, Name, structType, structPath, fieldPath) \
- (type)name { return structPath.fieldPath; } \
- (void)set##Name:(type)name { structType temp = structPath; temp.fieldPath = name; structPath = temp; } \


#pragma mark - inheritence

// shorthand to throw an exception in abstract base methods.
#define MUST_OVERRIDE qk_fail(@"must override in subclass or intermediate: %@", [self class])


// throw an exception for non-designated initialization paths:
// place this macro in the implementation of a subclass method
// that is implemented by superclass but should never get called.
#define NON_DESIGNATED_INIT(designated_name) \
[NSException raise:NSInternalInconsistencyException format:@"%s: non-designated initializer: instead use %@", __FUNCTION__, designated_name]; \
return nil


#pragma mark - delegates


#define DEL_RESPONDS(sel) ([self.delegate respondsToSelector:@selector(sel)] ? (id)self.delegate : nil)
#define DEL_PASS1(sel) [DEL_RESPONDS(sel:) sel:scrollView]
#define DEL_PASS2(sel1, sel2) [DEL_RESPONDS(sel1:sel2:) sel1:scrollView sel2:sel2]
#define DEL_PASS3(sel1, sel2, sel3) [DEL_RESPONDS(sel1:sel2:sel3:) sel1:scrollView sel2:sel2 sel3:sel3]


#pragma mark - blocks


// declare a temporary qualified version of a variable
#define BLOCK_VAR(temp,     var) __block                __typeof__(var) temp = var
#define WEAK_VAR(temp,      var) __weak                 __typeof__(var) temp = var
#define UNSAFE_VAR(temp,    var) __unsafe_unretained    __typeof__(var) temp = var

#define BLOCK(var)  BLOCK_VAR(block_ ## var,    var)
#define WEAK(var)   WEAK_VAR(weak_ ## var,      var)
#define UNSAFE(var) UNSAFE_VAR(unsafe_ ## var,  var)

// if block is live, apply it to arguments.
#define APPLY_LIVE_BLOCK(block, ...) \
{ __typeof__(block) __b = (block); if (__b) __b(__VA_ARGS__); }

// if block is live, apply it to arguments; otherwise return alt.
#define APPLY_BLOCK_ELSE(block, alt, ...) \
({ __typeof__(block) __b = (block); __b ? __b(__VA_ARGS__) : (alt); })

// if block is live, apply it to arguments; otherwise return nil.
#define APPLY_BLOCK_ELSE_NIL(block, ...) \
({ __typeof__(block) __b = (block); __b ? __b(__VA_ARGS__) : nil; })

// if block is live, apply it to arguments; otherwise return value.
#define APPLY_BLOCK_OR_IDENTITY(block, ...) \
({ __typeof__(block) __b = (block); __typeof__(__VA_ARGS__) __v = (__VA_ARGS__); __b ? __b(__v) : __v; })

#pragma mark - exceptions


// catch clause for non-critical try blocks, where we want to ignore failure
#define CATCH_AND_LOG @catch (id exception) { errFL(@"CAUGHT EXCEPTION: %s\n\%@", __FUNCTION__, exception); }


#pragma mark - threads


#define CHECK_MAIN_THREAD qk_check([NSThread isMainThread], @"requires main thread")
#define ASSERT_MAIN_THREAD qk_assert([NSThread isMainThread], @"requires main thread")

#define CHECK_NOT_MAIN_THREAD qk_check(![NSThread isMainThread], @"requires background thread")
#define ASSERT_NOT_MAIN_THREAD qk_assert(![NSThread isMainThread], @"requires background thread")

#define THREAD_SLEEP(interval) { \
NSTimeInterval _sleep_interval = (interval); \
errFL(@"THREAD_SLEEP: %f", _sleep_interval); \
[NSThread sleepForTimeInterval:_sleep_interval]; \
}


#pragma mark - miscellaneous cocoa utilities


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
