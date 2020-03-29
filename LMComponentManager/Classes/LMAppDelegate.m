//
//  LMAppDelegate.m
//  LMComponentManager
//
//  Created by Arclin on 2020/3/29.
//

#import "LMAppDelegate.h"

#import "LMAppDelegate.h"
#import "LMComponentManager.h"
#import "LMModuleManager.h"
#import "LMTimeProfiler.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@interface LMAppDelegate () <UNUserNotificationCenterDelegate>
#else
@interface LMAppDelegate ()
#endif


@end

@implementation LMAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LMModuleManager sharedManager] triggerEvent:LMSetupEvent];
    [[LMModuleManager sharedManager] triggerEvent:LMInitEvent];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LMModuleManager sharedManager] triggerEvent:LMSplashEvent];
    });
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
        if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    
#ifdef DEBUG
    [[LMTimeProfiler sharedTimeProfiler] saveTimeProfileDataIntoFile:@"LMComponentManagerTimeProfiler"];
#endif
    
    return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400

-(void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
API_AVAILABLE(ios(9.0)){
    [[LMComponentManager shareInstance].context.touchShortcutItem setShortcutItem: shortcutItem];
    [[LMComponentManager shareInstance].context.touchShortcutItem setScompletionHandler: completionHandler];
    [[LMModuleManager sharedManager] triggerEvent:LMQuickActionEvent];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[LMModuleManager sharedManager] triggerEvent:LMWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LMModuleManager sharedManager] triggerEvent:LMDidEnterBackgroundEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[LMModuleManager sharedManager] triggerEvent:LMWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LMModuleManager sharedManager] triggerEvent:LMDidBecomeActiveEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LMModuleManager sharedManager] triggerEvent:LMWillTerminateEvent];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[LMComponentManager shareInstance].context.openURLItem setOpenURL:url];
    [[LMComponentManager shareInstance].context.openURLItem setSourceApplication:sourceApplication];
    [[LMComponentManager shareInstance].context.openURLItem setAnnotation:annotation];
    [[LMModuleManager sharedManager] triggerEvent:LMOpenURLEvent];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
  
    [[LMComponentManager shareInstance].context.openURLItem setOpenURL:url];
    [[LMComponentManager shareInstance].context.openURLItem setOptions:options];
    [[LMModuleManager sharedManager] triggerEvent:LMOpenURLEvent];
    return YES;
}
#endif


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[LMModuleManager sharedManager] triggerEvent:LMDidReceiveMemoryWarningEvent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[LMComponentManager shareInstance].context.notificationsItem setNotificationsError:error];
    [[LMModuleManager sharedManager] triggerEvent:LMDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[LMComponentManager shareInstance].context.notificationsItem setDeviceToken: deviceToken];
    [[LMModuleManager sharedManager] triggerEvent:LMDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[LMComponentManager shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[LMModuleManager sharedManager] triggerEvent:LMDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[LMComponentManager shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[LMComponentManager shareInstance].context.notificationsItem setNotificationResultHander: completionHandler];
    [[LMModuleManager sharedManager] triggerEvent:LMDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[LMComponentManager shareInstance].context.notificationsItem setLocalNotification: notification];
    [[LMModuleManager sharedManager] triggerEvent:LMDidReceiveLocalNotificationEvent];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponentManager shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[LMModuleManager sharedManager] triggerEvent:LMDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponentManager shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[LMComponentManager shareInstance].context.userActivityItem setUserActivityError: error];
        [[LMModuleManager sharedManager] triggerEvent:LMDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponentManager shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[LMComponentManager shareInstance].context.userActivityItem setRestorationHandler: restorationHandler];
        [[LMModuleManager sharedManager] triggerEvent:LMContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[LMComponentManager shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[LMModuleManager sharedManager] triggerEvent:LMWillContinueUserActivityEvent];
    }
    return YES;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [LMComponentManager shareInstance].context.watchItem.userInfo = userInfo;
        [LMComponentManager shareInstance].context.watchItem.replyHandler = reply;
        [[LMModuleManager sharedManager] triggerEvent:LMHandleWatchKitExtensionRequestEvent];
    }
}
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)){
    [[LMComponentManager shareInstance].context.notificationsItem setNotification: notification];
    [[LMComponentManager shareInstance].context.notificationsItem setNotificationPresentationOptionsHandler: completionHandler];
    [[LMComponentManager shareInstance].context.notificationsItem setCenter:center];
    [[LMModuleManager sharedManager] triggerEvent:LMWillPresentNotificationEvent];
};

- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    [[LMComponentManager shareInstance].context.notificationsItem setNotificationResponse: response];
    [[LMComponentManager shareInstance].context.notificationsItem setNotificationCompletionHandler:completionHandler];
    [[LMComponentManager shareInstance].context.notificationsItem setCenter:center];
    [[LMModuleManager sharedManager] triggerEvent:LMDidReceiveNotificationResponseEvent];
};
#endif

@end

@implementation LMOpenURLItem

@end

@implementation LMShortcutItem

@end

@implementation LMUserActivityItem

@end

@implementation LMNotificationsItem

@end
