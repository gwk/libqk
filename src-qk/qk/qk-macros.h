// Copyright 2008 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

// General purpose utility macros.

/*
 qk_check is an assertion macro intended for production use.
 qk_assert is exactly like check, unless QK_OPTIMIZE is true, in which case it is a no-op.
 qk_fail is identical to check, but is not predicated on a conditional.
 all of these macros throw an objective-c exception.
 */


#import "qk-types.h"


#ifndef QK_OPTIMIZE
# ifdef NDEBUG
#   define QK_OPTIMIZE 1
# else
#   define QK_OPTIMIZE 0
# endif
#endif


#define _qk_fail(expr_str, fmt, ...) ({ \
NSString* expr_line = expr_str ? [NSString stringWithFormat:@"failed expr: '%s'\n  ", expr_str] : @""; \
NSString* file_str = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
NSString* msg = [NSString stringWithFormat:@"ERROR: %@:%d: %s\n  %@" fmt, \
file_str, __LINE__, __PRETTY_FUNCTION__, expr_line, ##__VA_ARGS__]; \
NSLog(@"%@", msg); \
[NSException raise:NSInternalInconsistencyException format:@"%@", msg]; \
abort(); \
})

# define qk_fail(...) _qk_fail((char*)NULL, __VA_ARGS__)

#define qk_warn(...) NSLog(@"WARNING: " __VA_ARGS__)

# define qk_check(expr, ...) \
((expr) ? (void)0 : _qk_fail(#expr, __VA_ARGS__))

// soft checks simply print an error message
# define qk_check_soft(expr, ...) \
((void)((expr) ? 0 : NSLog(@"ERROR: soft check failed: %@:%d: %s\n! %s\n%@\n", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, \
#expr, [NSString stringWithFormat:__VA_ARGS__])))


// type checks

#define CHECK_KIND(obj, class_name) \
qk_check([(obj) isKindOfClass:[class_name class]], \
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


#if QK_OPTIMIZE // release
# define qk_assert(expr, ...) ((void)0)
# define qk_assert_soft(expr, ...) ((void)0)
# define ASSERT_KIND(obj, class_name) ((void)0)
# define ASSERT_KIND_OR_NIL(obj, class_name) ((void)0)
# define ASSERT_CONFORMS(obj, protocol_name) ((void)0)
# define ASSERT_CONFORMS_OR_NIL(obj, protocol_name) ((void)0)
#else // debug
# define qk_assert(expr, ...) qk_check((expr), __VA_ARGS__)
# define qk_assert_soft(expr, ...) qk_check_soft((expr), __VA_ARGS__)
# define ASSERT_KIND(obj, class_name) CHECK_KIND((obj), class_name)
# define ASSERT_KIND_OR_NIL(obj, class_name) CHECK_KIND_OR_NIL((obj), class_name)
# define ASSERT_CONFORMS(obj, protocol_name) CHECK_CONFORMS((obj), protocol_name)
# define ASSERT_CONFORMS_OR_NIL(obj, protocol_name) CHECK_CONFORMS_OR_NIL((obj), protocol_name)
#endif // QK_OPTIMIZE


// cast with a run-time type kind assertion
#define CAST(class_name, ...) \
({ id __cast_obj = (__VA_ARGS__); ASSERT_KIND_OR_NIL(__cast_obj, class_name); (class_name*)__cast_obj; })

#define CAST_PROTO(protocol_name, ...) \
({ id __cast_obj = (__VA_ARGS__); ASSERT_CONFORMS_OR_NIL(__cast_obj, protocol_name); (id<protocol_name>)__cast_obj; })


#define CHECK_RET_ERROR(expr, domain_prefix, code_suffix, _desc, ...) \
if (!(expr)) { \
return [NSError withDomain:domain_prefix##ErrorDomain \
code:domain_prefix##ErrorCode##code_suffix \
desc:(_desc) \
info:__VA_ARGS__]; \
}

#define CHECK_SET_ERROR_RET_NIL(expr, domain_prefix, code_suffix, _desc, ...) \
if (!(expr)) { \
NSString* __desc = (_desc); \
NSDictionary* __info = (__VA_ARGS__); \
NSMutableDictionary* __userInfo = [__info mutableCopy]; \
__userInfo[NSLocalizedDescriptionKey] = OBJ_OR_NULL(__desc); \
qk_check(errorPtr, @"%@ (no errorPtr provided): %@", __desc, __userInfo); \
*errorPtr = [NSError errorWithDomain:domain_prefix##ErrorDomain \
code:domain_prefix##ErrorCode##code_suffix \
userInfo:__userInfo.copy]; \
return nil; \
}


#pragma mark - inheritence

// shorthand to throw an exception in abstract base methods.
#define MUST_OVERRIDE qk_fail(@"must override in subclass or intermediate: %@", [self class])

// throw an exception for non-designated initialization paths.
// place this macro in the implementation of a subclass method that is implemented by superclass but should never get called.
#define NOT_DESIGNATED_INIT(designated_name) \
[NSException raise:NSInternalInconsistencyException format:@"%s: non-designated initializer: instead use %@", __FUNCTION__, designated_name]; \
return nil


#pragma mark - threads

#define CHECK_MAIN_THREAD qk_check([NSThread isMainThread], @"requires main thread")
#define ASSERT_MAIN_THREAD qk_assert([NSThread isMainThread], @"requires main thread")

#define CHECK_NOT_MAIN_THREAD qk_check(![NSThread isMainThread], @"requires background thread")
#define ASSERT_NOT_MAIN_THREAD qk_assert(![NSThread isMainThread], @"requires background thread")


#define ASSERT_WCHAR_IS_UTF32 qk_assert(sizeof(wchar_t) == 4, @"bad wchar_t size: %lu", sizeof(wchar_t))

// basic macros

#define loop while (1) // infinite loop

// for Int 'i' from 'm' to 'n' in increments of 's'.
#define for_imns(i, m, n, s) \
for (Int i = (m), _##i##_end = (n), _##i##_step = (s); i < _##i##_end; i += _##i##_step)

// produces the same values for i as above, but in reverse order.
#define for_imns_rev(i, m, n, s) \
for (Int i = (n) - 1, _##i##_end = (m), _##i##_step = (s); i >= _##i##_end; i -= _##i##_step)

// same as for_imns(i, m, n, 0).
#define for_imn(i, m, n)      for_imns(i, (m), (n), 1)
#define for_imn_rev(i, m, n)  for_imns_rev(i, (m), (n), 1)

// same as for_imn(i, 0, n).
#define for_in(i, n)      for_imns(i, 0, (n), 1)
#define for_in_rev(i, n)  for_imns_rev(i, 0, (n), 1)

// returns -1, 0, or 1 based on sign of input.
#define sign(x) ({__typeof__(x) __x = (x); __x > 0 ? 1 : (__x < 0 ? -1 : 0); })

// use the cast macro to make all casts easily searchable for audits.
#define cast(t, ...) (t)(__VA_ARGS__)

// used to create switch statements that return strings for enum names.
#define CASE_RET_TOK(t) case t: return #t
#define CASE_RET_TOK_SPLIT(prefix, t) case prefix##t: return #t

// boolean logic
#define bit(x) (!!(x))
#define XOR(a, b) (bit(a) ^ bit(b))

// mark function as never returning. ex: NORETURN f() {...}
#define NORETURN __attribute__((noreturn)) void

// suppress compiler warnings. ex: UNUSED_FN f() {...}
#define UNUSED_FN __attribute__((unused))

// suppress unused var warnings.
#define STRING_FROM_TOKEN(x) #x
#define UNUSED_VAR(x) _Pragma(STRING_FROM_TOKEN(unused(x)))


// more macros


// used to create switch statements that return strings for enum names.
#define CASE_RET_TOK_STR(t) case t: return @#t
#define CASE_RET_TOK_SPLIT_STR(prefix, t) case prefix##t: return @#t


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

#define COMPARE_RET_IF_DIFF(c, a, b) c = COMPARE(a, b); if (c != NSOrderedSame) return c;

#define UPDATE_MAX(var, val) ({ __typeof__(val) __val = (val); if (var < __val) var = __val; })
#define UPDATE_MIN(var, val) ({ __typeof__(val) __val = (val); if (var > __val) var = __val; })


#define LAZY_STATIC_FN(type, name, ...) \
type name() { \
  static type name = __VA_ARGS__; \
return name; \
}


#ifdef __OBJC__


// get a "Y" or "N" string from the boolean value of an expression
#define BIT_YN(x) ((x) ? @"Y" : @"N")


#pragma mark - types


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
({ class_name* __obj = (id)(obj); (IS_KIND((__obj), class_name) ? __obj : nil); })


// return the object if it is of the specified class, or else NSNull
// this is useful for specifying values for dictionaryWithObjectsForKeys:
#define KIND_OR_NULL(obj, class_name) \
({ id __obj = (obj); IS_KIND(__obj, class_name) ? __obj : [NSNull null]; })


#define OBJ_OR_NULL(obj) \
({ id __obj = (obj); (__obj ? __obj : [NSNull null]); })


// return the object if it is non-nil, else return the alternate.
// necessary because ARC forbids a || b syntax with objc pointers.
#define LIVE_ELSE(obj, alternate) \
({ id __obj = (obj); __obj ? __obj : (alternate); })



#pragma mark - reference counting


// retain cycle mitigation
#define DISSOLVE(obj) { [(obj) dissolve]; (obj) = nil; }

#define DEF_DEALLOC_DISSOLVE \
- (void)dealloc { [self dissolve]; } \
- (void)dissolve


#pragma mark - initialization


// shorthand for the cocoa init idiom.
#define INIT(...) if (!((self = ([__VA_ARGS__])))) return nil


#define DEC_WITH(...) \
+ (instancetype)with##__VA_ARGS__;

#define DEF_WITH(...) \
+ (instancetype)with##__VA_ARGS__ { return [[self alloc] initWith##__VA_ARGS__]; }

// if there are multiple init methods with the same name the compiler refuses to choose, because alloc returns id.
// use an explicit cast of the new instance to guide it to correct init signature.
#define DEF_WITH_CAST(class_name, ...) \
+ (instancetype)with##__VA_ARGS__ { return [(class_name*)[self alloc] initWith##__VA_ARGS__]; }

// define + (instancetype)with... and - (instancetype)initWith... simultaneously.
#define DEC_INIT(...) \
+ (instancetype)with##__VA_ARGS__; \
- (instancetype)initWith##__VA_ARGS__

#define DEF_INIT(...) \
DEF_WITH(__VA_ARGS__) \
- (instancetype)initWith##__VA_ARGS__


#define DEF_INIT_CAST(class_name, ...) \
DEF_WITH_CAST(class_name, __VA_ARGS__) \
- (instancetype)initWith##__VA_ARGS__


#define DEF_SET_AND_DISPLAY(type, name, Name) \
- (void)set##Name:(type)name { _##name = name; [self setNeedsDisplay]; }

#define DEF_SET_CF_RETAIN(type, name, Name) \
- (void)set##Name:(type)name { type old = _##name; _##name = (type)(name ? CFRetain(name) : NULL); if (old) CFRelease(old); }


#pragma mark - properties


#define PROPERTY_ALIAS(type, name, Name, path, ...) \
- (type)name { return (type)path; } \
- (void)set##Name:(type)name { path = name; __VA_ARGS__ } \


#define PROPERTY_SUBCLASS_ALIAS(class_name, name, Name, path, ...) \
- (class_name*)name { return CAST(class_name, path); } \
- (void)set##Name:(class_name*)name { path = name; __VA_ARGS__ } \


#define PROPERTY_SUBCLASS_ALIAS_RO(class_name, name, path) \
- (class_name*)name { return CAST(class_name, path); } \


#define PROPERTY_STRUCT_FIELD(type, name, Name, structType, structPath, fieldPath, ...) \
- (type)name { return structPath.fieldPath; } \
- (void)set##Name:(type)name { structType temp = structPath; temp.fieldPath = name; structPath = temp; __VA_ARGS__ } \


#pragma mark - delegates


#define DEL_RESPONDS(sel) ([self.delegate respondsToSelector:@selector(sel)] ? (id)self.delegate : nil)
#define DEL_PASS1(sel) [DEL_RESPONDS(sel:) sel:scrollView]
#define DEL_PASS2(sel1, sel2) [DEL_RESPONDS(sel1:sel2:) sel1:scrollView sel2:sel2]
#define DEL_PASS3(sel1, sel2, sel3) [DEL_RESPONDS(sel1:sel2:sel3:) sel1:scrollView sel2:sel2 sel3:sel3]


#pragma mark - blocks


// declare a temporary qualified version of a variable.
// note that in ARC, __block retains objects, so it does not prevent retain cycles; use WEAK or BACK instead.
#define WEAK_VAR(temp,  var) __weak               __typeof__(var) temp = var
#define BACK_VAR(temp,  var) __unsafe_unretained  __typeof__(var) temp = var
#define BLOCK_VAR(temp, var) __block              __typeof__(var) temp = var

#define WEAK(var)   WEAK_VAR(weak_ ## var,    var)
#define BACK(var)   BACK_VAR(back_ ## var,  var)
#define BLOCK(var)  BLOCK_VAR(block_ ## var,  var)

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


#define THREAD_SLEEP(interval) { \
NSTimeInterval _sleep_interval = (interval); \
NSLog(@"THREAD_SLEEP: %f", _sleep_interval); \
[NSThread sleepForTimeInterval:_sleep_interval]; \
}


#pragma mark - miscellaneous cocoa utilities


#define NSRangeMake NSMakeRange

#define NSRangeTo(to) NSRangeMake(0, (to))

#define NSRangeLength(obj)  NSRangeTo([(obj) length])
#define NSRangeCount(obj)   NSRangeTo([(obj) count])


#define LAZY_STATIC_METHOD(type, name, ...) \
+ (type)name { \
static type name = __VA_ARGS__; \
return name; \
}


#define DEC_DEFAULT(type, Name) \
+ (type)default##Name; \
+ (void)setDefault##Name:(type)d;

#define DEF_DEFAULT(type, Name) \
static type _default##Name; \
+ (type)default##Name { return _default##Name; } \
+ (void)setDefault##Name:(type)d { _default##Name = d; }


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


#ifdef __cplusplus

# define FOR_I(container_type, itor_name, container) \
for (container_type::iterator itor_name = (container).begin(); itor_name != (container).end(); ++itor_name)

# define FOR_CI(container_type, itor_name, container) \
for (container_type::const_iterator itor_name = (container).begin(); itor_name != (container).end(); ++itor_name)


# define FILL(pointer, size, value) std::fill((pointer), (pointer) + (size), (value))

# define SORT(pointer, size) std::sort((pointer), (pointer) + (size))


#endif // __cplusplus
