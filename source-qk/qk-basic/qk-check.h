// Copyright 2010 George King.
// Permission to use this file is granted in libqk/license.txt.

/*
check is an assertion macro intended for production use.
note that for many applications, exiting on errors is not appropriate.

check differs from assert in the following ways:
the call does not disappear when NDEBUG is defined (although console messages become more concise);
the call requires a c string description argument.

fail is identical to check, but is not predicated on a conditional. 

all of these macros throw an exception in objctive-c or c++, unless NFAILTHROWS is defined.
catching assertions can be helpful for reducing problematic input data sets.

the BREAK macro provides a console driven break mechanism.

inflential macros:
NDEBUG:        asserts expand to nothing
NFAILTHROWS:   failures never throw exceptions, just abort
*/


#define BREAK _pseudo_breakpoint(__FILE__, __LINE__, __func__)

// replace system assert and check with our own
#undef assert
#undef check


# define check(expr, ...) \
((expr) ? (void)0 : _qk_fail(__FILE__, __LINE__, __func__, #expr, [NSString stringWithFormat:__VA_ARGS__]))

# define fail(...) _qk_fail(__FILE__, __LINE__, __func__, NULL, [NSString stringWithFormat:__VA_ARGS__])

// soft checks simply print an error message
# define check_soft(expr, ...) \
((void)((expr) ? 0 : NSLog(@"ERROR: soft check failed: %s:%d: %s\n%s\n%@\n", \
__FILE__, __LINE__, __func__, #expr, [NSString stringWithFormat:__VA_ARGS__])))


#ifdef NDEBUG // turn assertions off

# define assert(expr, ...) ((void)0)
# define assert_soft(expr, ...) ((void)0)

#else // NDEBUG

# define assert(expr, ...) check((expr), __VA_ARGS__)
# define assert_soft(expr, ...) check_soft((expr), __VA_ARGS__)

#endif // NDEBUG

#define ASSERT_WCHAR_IS_UTF32 assert(sizeof(wchar_t) == 4, @"bad wchar_t size: %lu", sizeof(wchar_t))


#ifdef __cplusplus
extern "C" {
#endif
  
void __attribute__((noreturn))
_qk_fail(const char* file, int line, const char* func, const char* expr_str, NSString* msg);
  
void _qk_pseudo_breakpoint(const char* file, int line, const char* func);

#ifdef __cplusplus
}
#endif
    
