//
//  LMAppDelegateItem.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/16.
//

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

typedef void (^LMNotificationResultHandler)(UIBackgroundFetchResult);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
typedef void (^LMNotificationPresentationOptionsHandler)(UNNotificationPresentationOptions options);
typedef void (^LMNotificationCompletionHandler)();
#endif

@interface LMNotificationsItem : NSObject

@property (nonatomic, strong) NSError *notificationsError;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) LMNotificationResultHandler notificationResultHander;
@property (nonatomic, strong) UILocalNotification *localNotification;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@property (nonatomic, strong) UNNotification *notification;
@property (nonatomic, strong) UNNotificationResponse *notificationResponse;
@property (nonatomic, copy) LMNotificationPresentationOptionsHandler notificationPresentationOptionsHandler;
@property (nonatomic, copy) LMNotificationCompletionHandler notificationCompletionHandler;
@property (nonatomic, strong) UNUserNotificationCenter *center;
#endif

@end

@interface LMOpenURLItem : NSObject

@property (nonatomic, strong) NSURL *openURL;
@property (nonatomic, copy) NSString *sourceApplication;
@property (nonatomic, strong) id annotation;
@property (nonatomic, strong) NSDictionary *options;

@end

typedef void (^LMShortcutCompletionHandler)(BOOL);

@interface LMShortcutItem : NSObject

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property(nonatomic, strong) UIApplicationShortcutItem *shortcutItem;
@property(nonatomic, copy) LMShortcutCompletionHandler scompletionHandler;
#endif

@end


typedef void (^LMUserActivityRestorationHandler)(NSArray *);

@interface LMUserActivityItem : NSObject

@property (nonatomic, copy) NSString *userActivityType;
@property (nonatomic, strong) NSUserActivity *userActivity;
@property (nonatomic, strong) NSError *userActivityError;
@property (nonatomic, copy) LMUserActivityRestorationHandler restorationHandler;

@end

typedef void (^LMWatchReplyHandler)(NSDictionary *replyInfo);

@interface LMWatchItem : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) LMWatchReplyHandler replyHandler;

@end

@interface LMAppDelegateItem : NSObject

@end
