//
//  LMAppDelegate.m
//  LMComponentManager
//
//  Created by arclin@dankal.cn on 02/28/2020.
//  Copyright (c) 2020 arclin@dankal.cn. All rights reserved.
//

#import "LMAppDelegate.h"
#import <LMComponent.h>
#import <LMTimeProfiler.h>
#import <LMTimeProfiler.h>

#import <UserNotifications/UserNotifications.h>

@implementation LMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LMComponentManager sharedManager] triggerEvent:LMSetupEvent];
    [[LMComponentManager sharedManager] triggerEvent:LMInitEvent];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LMComponentManager sharedManager] triggerEvent:LMSplashEvent];
    });
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#endif
    
#ifdef DEBUG
    [[LMTimeProfiler sharedTimeProfiler] saveTimeProfileDataIntoFile:@"LMComponentTimeProfiler"];
#endif
    
    return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    [[LMComponent shareInstance].context.touchShortcutItem setShortcutItem: shortcutItem];
    [[LMComponent shareInstance].context.touchShortcutItem setScompletionHandler: completionHandler];
    [[LMComponentManager sharedManager] triggerEvent:LMQuickActionEvent];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[LMComponentManager sharedManager] triggerEvent:LMWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LMComponentManager sharedManager] triggerEvent:LMDidEnterBackgroundEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[LMComponentManager sharedManager] triggerEvent:LMWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LMComponentManager sharedManager] triggerEvent:LMDidBecomeActiveEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LMComponentManager sharedManager] triggerEvent:LMWillTerminateEvent];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[LMComponent shareInstance].context.openURLItem setOpenURL:url];
    [[LMComponent shareInstance].context.openURLItem setSourceApplication:sourceApplication];
    [[LMComponent shareInstance].context.openURLItem setAnnotation:annotation];
    [[LMComponentManager sharedManager] triggerEvent:LMOpenURLEvent];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
  
    [[LMComponent shareInstance].context.openURLItem setOpenURL:url];
    [[LMComponent shareInstance].context.openURLItem setOptions:options];
    [[LMComponentManager sharedManager] triggerEvent:LMOpenURLEvent];
    return YES;
}
#endif


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[LMComponentManager sharedManager] triggerEvent:LMDidReceiveMemoryWarningEvent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[LMComponent shareInstance].context.notificationsItem setNotificationsError:error];
    [[LMComponentManager sharedManager] triggerEvent:LMDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[LMComponent shareInstance].context.notificationsItem setDeviceToken: deviceToken];
    [[LMComponentManager sharedManager] triggerEvent:LMDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[LMComponent shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[LMComponentManager sharedManager] triggerEvent:LMDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[LMComponent shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[LMComponent shareInstance].context.notificationsItem setNotificationResultHander: completionHandler];
    [[LMComponentManager sharedManager] triggerEvent:LMDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[LMComponent shareInstance].context.notificationsItem setLocalNotification: notification];
    [[LMComponentManager sharedManager] triggerEvent:LMDidReceiveLocalNotificationEvent];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponent shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[LMComponentManager sharedManager] triggerEvent:LMDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponent shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[LMComponent shareInstance].context.userActivityItem setUserActivityError: error];
        [[LMComponentManager sharedManager] triggerEvent:LMDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponent shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[LMComponent shareInstance].context.userActivityItem setRestorationHandler: restorationHandler];
        [[LMComponentManager sharedManager] triggerEvent:LMContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponent shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[LMComponentManager sharedManager] triggerEvent:LMWillContinueUserActivityEvent];
    }
    return YES;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [LMComponent shareInstance].context.watchItem.userInfo = userInfo;
        [LMComponent shareInstance].context.watchItem.replyHandler = reply;
        [[LMComponentManager sharedManager] triggerEvent:LMHandleWatchKitExtensionRequestEvent];
    }
}
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [[LMComponent shareInstance].context.notificationsItem setNotification: notification];
    [[LMComponent shareInstance].context.notificationsItem setNotificationPresentationOptionsHandler: completionHandler];
    [[LMComponent shareInstance].context.notificationsItem setCenter:center];
    [[LMComponentManager sharedManager] triggerEvent:LMWillPresentNotificationEvent];
};

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    [[LMComponent shareInstance].context.notificationsItem setNotificationResponse: response];
    [[LMComponent shareInstance].context.notificationsItem setNotificationCompletionHandler:completionHandler];
    [[LMComponent shareInstance].context.notificationsItem setCenter:center];
    [[LMComponentManager sharedManager] triggerEvent:LMDidReceiveNotificationResponseEvent];
};
#endif

@end
