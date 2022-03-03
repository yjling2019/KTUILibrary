//
//  scope.h
//  qrhelper
//
//  Created by KOTU on 5/30/16.
//  Copyright © 2016 demiwan. All rights reserved.
//

#ifndef scope_h
#define scope_h

// weakify, strongify define
#include "KTMetamacros.h"

#define weakify(...) \
ext_keywordify \
metamacro_foreach_cxt(ext_weakify_,, __weak, __VA_ARGS__)

#define unsafeify(...) \
ext_keywordify \
metamacro_foreach_cxt(ext_weakify_,, __unsafe_unretained, __VA_ARGS__)

#define strongify(...) \
ext_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(ext_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

#define ext_weakify_(INDEX, CONTEXT, VAR) \
CONTEXT __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR);

#define ext_strongify_(INDEX, VAR) \
__strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_);

#if DEBUG
#define ext_keywordify autoreleasepool {}
#else
#define ext_keywordify try {} @catch (...) {}
#endif


typedef id (^KTWeakReferenceBlock)(void);
static inline KTWeakReferenceBlock kt_delay(id object) {
	__weak id weakReference = object;
	return ^{
		return weakReference;
	};
}

static inline id kt_force(KTWeakReferenceBlock weakReference) {
	return weakReference ? weakReference() : nil;
}

#endif /* scope_h */

