//
//  ALAppDelegate.m
//  ALComponentManager
//
//  Created by Arclin on 2020/3/29.
//

#import "ALAppDelegate.h"

#import "ALAppDelegate.h"
#import "ALComponentManager.h"
#import "ALModuleManager.h"
#import "ALTimeProfiler.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@interface ALAppDelegate () <UNUserNotificationCenterDelegate>
#else
@interface ALAppDelegate ()
#endif


@end

@implementation ALAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ALContext shareInstance].application = application;
    [ALContext shareInstance].launchOptions = launchOptions;
    
    [[ALComponentManager shareInstance] setContext:[ALContext shareInstance]];
#ifdef DEBUG
    [[ALTimeProfiler sharedTimeProfiler] recordEventTime:@"super start launch"];
#endif
    
    [[ALModuleManager sharedManager] triggerEvent:ALSetupEvent];
    [[ALModuleManager sharedManager] triggerEvent:ALInitEvent];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ALModuleManager sharedManager] triggerEvent:ALSplashEvent];
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
    [[ALTimeProfiler sharedTimeProfiler] saveTimeProfileDataIntoFile:@"ALComponentManagerTimeProfiler"];
#endif
    
    return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400

-(void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
API_AVAILABLE(ios(9.0)){
    [[ALComponentManager shareInstance].context.touchShortcutItem setShortcutItem: shortcutItem];
    [[ALComponentManager shareInstance].context.touchShortcutItem setScompletionHandler: completionHandler];
    [[ALModuleManager sharedManager] triggerEvent:ALQuickActionEvent];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[ALModuleManager sharedManager] triggerEvent:ALWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ALModuleManager sharedManager] triggerEvent:ALDidEnterBackgroundEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[ALModuleManager sharedManager] triggerEvent:ALWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[ALModuleManager sharedManager] triggerEvent:ALDidBecomeActiveEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ALModuleManager sharedManager] triggerEvent:ALWillTerminateEvent];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[ALComponentManager shareInstance].context.openURLItem setOpenURL:url];
    [[ALComponentManager shareInstance].context.openURLItem setSourceApplication:sourceApplication];
    [[ALComponentManager shareInstance].context.openURLItem setAnnotation:annotation];
    [[ALModuleManager sharedManager] triggerEvent:ALOpenURLEvent];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
  
    [[ALComponentManager shareInstance].context.openURLItem setOpenURL:url];
    [[ALComponentManager shareInstance].context.openURLItem setOptions:options];
    [[ALModuleManager sharedManager] triggerEvent:ALOpenURLEvent];
    return YES;
}
#endif


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[ALModuleManager sharedManager] triggerEvent:ALDidReceiveMemoryWarningEvent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[ALComponentManager shareInstance].context.notificationsItem setNotificationsError:error];
    [[ALModuleManager sharedManager] triggerEvent:ALDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[ALComponentManager shareInstance].context.notificationsItem setDeviceToken: deviceToken];
    [[ALModuleManager sharedManager] triggerEvent:ALDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[ALComponentManager shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[ALModuleManager sharedManager] triggerEvent:ALDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[ALComponentManager shareInstance].context.notificationsItem setUserInfo: userInfo];
    [[ALComponentManager shareInstance].context.notificationsItem setNotificationResultHander: completionHandler];
    [[ALModuleManager sharedManager] triggerEvent:ALDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[ALComponentManager shareInstance].context.notificationsItem setLocalNotification: notification];
    [[ALModuleManager sharedManager] triggerEvent:ALDidReceiveLocalNotificationEvent];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[ALComponentManager shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[ALModuleManager sharedManager] triggerEvent:ALDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[ALComponentManager shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[ALComponentManager shareInstance].context.userActivityItem setUserActivityError: error];
        [[ALModuleManager sharedManager] triggerEvent:ALDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[ALComponentManager shareInstance].context.userActivityItem setUserActivity: userActivity];
        [[ALComponentManager shareInstance].context.userActivityItem setRestorationHandler: restorationHandler];
        [[ALModuleManager sharedManager] triggerEvent:ALContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [[ALComponentManager shareInstance].context.userActivityItem setUserActivityType: userActivityType];
        [[ALModuleManager sharedManager] triggerEvent:ALWillContinueUserActivityEvent];
    }
    return YES;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        [ALComponentManager shareInstance].context.watchItem.userInfo = userInfo;
        [ALComponentManager shareInstance].context.watchItem.replyHandler = reply;
        [[ALModuleManager sharedManager] triggerEvent:ALHandleWatchKitExtensionRequestEvent];
    }
}
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)){
    [[ALComponentManager shareInstance].context.notificationsItem setNotification: notification];
    [[ALComponentManager shareInstance].context.notificationsItem setNotificationPresentationOptionsHandler: completionHandler];
    [[ALComponentManager shareInstance].context.notificationsItem setCenter:center];
    [[ALModuleManager sharedManager] triggerEvent:ALWillPresentNotificationEvent];
};

- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    [[ALComponentManager shareInstance].context.notificationsItem setNotificationResponse: response];
    [[ALComponentManager shareInstance].context.notificationsItem setNotificationCompletionHandler:completionHandler];
    [[ALComponentManager shareInstance].context.notificationsItem setCenter:center];
    [[ALModuleManager sharedManager] triggerEvent:ALDidReceiveNotificationResponseEvent];
};
#endif

@end

@implementation ALOpenURLItem

@end

@implementation ALShortcutItem

@end

@implementation ALUserActivityItem

@end

@implementation ALNotificationsItem

@end
