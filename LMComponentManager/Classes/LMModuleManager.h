//
//  LMModuleManager.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LMComponentLevel)
{
    LMComponentBasic  = 0,
    LMComponentNormal = 1
};

typedef NS_ENUM(NSInteger, LMComponentEventType)
{
    LMSetupEvent = 0,
    LMInitEvent,
//    LMTearDownEvent,
    LMSplashEvent,
    LMQuickActionEvent,
    LMWillResignActiveEvent,
    LMDidEnterBackgroundEvent,
    LMWillEnterForegroundEvent,
    LMDidBecomeActiveEvent,
    LMWillTerminateEvent,
    LMUnmountEvent,
    LMOpenURLEvent,
    LMDidReceiveMemoryWarningEvent,
    LMDidFailToRegisterForRemoteNotificationsEvent,
    LMDidRegisterForRemoteNotificationsEvent,
    LMDidReceiveRemoteNotificationEvent,
    LMDidReceiveLocalNotificationEvent,
    LMWillPresentNotificationEvent,
    LMDidReceiveNotificationResponseEvent,
    LMWillContinueUserActivityEvent,
    LMContinueUserActivityEvent,
    LMDidFailToContinueUserActivityEvent,
    LMDidUpdateUserActivityEvent,
    LMHandleWatchKitExtensionRequestEvent,
    LMDidCustomEvent = 1000
};

@interface LMModuleManager : NSObject

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
