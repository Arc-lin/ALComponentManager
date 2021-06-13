#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ALAnnotation.h"
#import "ALAppDelegate.h"
#import "ALComponentManager.h"
#import "ALComponentProtocol.h"
#import "ALContext.h"
#import "ALModuleManager.h"
#import "ALTimeProfiler.h"

FOUNDATION_EXPORT double ALComponentManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char ALComponentManagerVersionString[];

