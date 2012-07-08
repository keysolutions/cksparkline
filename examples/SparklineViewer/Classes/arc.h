#ifndef arc_h
#define arc_h

// Define ARC_RETAIN/ARC_RELEASE macros for conditional support of the ARC 
// memory management features. When ARC is enabled, the value is assigned
// to itself to silence compiler warnings.

#if ! __has_feature(objc_arc)

    #define ARC_RETAIN(o) [(o) retain]
    #define ARC_RELEASE(o) [(o) release]

#else

    #define ARC_RETAIN(o) (o = o)
    #define ARC_RELEASE(o) (o = o)

#endif

#endif
