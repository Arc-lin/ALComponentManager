//
//  ALModuleManager.h
//  ALComponentManager
//
//  Created by Arclin on 2020/3/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ALComponentLevel)
{
    ALComponentBasic  = 0,
    ALComponentNormal = 1
};

typedef NS_ENUM(NSInteger, ALComponentEventType)
{
    ALSetupEvent = 0,
    ALInitEvent,
//    ALTearDownEvent,
    ALSplashEvent,
    ALQuickActionEvent,
    ALWillResignActiveEvent,
    ALDidEnterBackgroundEvent,
    ALWillEnterForegroundEvent,
    ALDidBecomeActiveEvent,
    ALWillTerminateEvent,
    ALUnmountEvent,
    ALOpenURLEvent,
    ALDidReceiveMemoryWarningEvent,
    ALDidFailToRegisterForRemoteNotificationsEvent,
    ALDidRegisterForRemoteNotificationsEvent,
    ALDidReceiveRemoteNotificationEvent,
    ALDidReceiveLocalNotificationEvent,
    ALWillPresentNotificationEvent,
    ALDidReceiveNotificationResponseEvent,
    ALWillContinueUserActivityEvent,
    ALContinueUserActivityEvent,
    ALDidFailToContinueUserActivityEvent,
    ALDidUpdateUserActivityEvent,
    ALHandleWatchKitExtensionRequestEvent,
    ALDidCustomEvent = 1000
};

@interface ALModuleManager : NSObject

+ (instancetype)sharedManager;

- (void)registerDynamicModule:(Class)moduleClass;

- (void)registerDynamicModule:(Class)moduleClass
       shouldTriggerInitEvent:(BOOL)shouldTriggerInitEvent;

- (void)unRegisterDynamicModule:(Class)moduleClass;

- (void)registedAllModules;

- (void)registerCustomEvent:(NSInteger)eventType
         withModuleInstance:(id)moduleInstance
             andSelectorStr:(NSString *)selectorStr;

- (void)triggerEvent:(NSInteger)eventType;

- (void)triggerEvent:(NSInteger)eventType
     withCustomParam:(NSDictionary *)customParam;


@end
