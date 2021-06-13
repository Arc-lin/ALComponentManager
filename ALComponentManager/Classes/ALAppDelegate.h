//
//  ALAppDelegate.h
//  ALComponentManager
//
//  Created by Arclin on 2020/3/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@interface ALAppDelegate: UIResponder <UIApplicationDelegate>

@end

typedef void (^ALNotificationResultHandler)(UIBackgroundFetchResult);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
typedef void (^ALNotificationPresentationOptionsHandler)(UNNotificationPresentationOptions options);
typedef void (^ALNotificationCompletionHandler)();
#endif

@interface ALNotificationsItem : NSObject

@property (nonatomic, strong) NSError *notificationsError;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) ALNotificationResultHandler notificationResultHander;
@property (nonatomic, strong) UILocalNotification *localNotification;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@property (nonatomic, strong) UNNotification *notification;
@property (nonatomic, strong) UNNotificationResponse *notificationResponse;
@property (nonatomic, copy) ALNotificationPresentationOptionsHandler notificationPresentationOptionsHandler;
@property (nonatomic, copy) ALNotificationCompletionHandler notificationCompletionHandler;
@property (nonatomic, strong) UNUserNotificationCenter *center;
#endif

@end

@interface ALOpenURLItem : NSObject

@property (nonatomic, strong) NSURL *openURL;
@property (nonatomic, copy) NSString *sourceApplication;
@property (nonatomic, strong) id annotation;
@property (nonatomic, strong) NSDictionary *options;

@end

typedef void (^ALShortcutCompletionHandler)(BOOL);

@interface ALShortcutItem : NSObject

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property(nonatomic, strong) UIApplicationShortcutItem *shortcutItem;
@property(nonatomic, copy) ALShortcutCompletionHandler scompletionHandler;
#endif

@end


typedef void (^ALUserActivityRestorationHandler)(NSArray *);

@interface ALUserActivityItem : NSObject

@property (nonatomic, copy) NSString *userActivityType;
@property (nonatomic, strong) NSUserActivity *userActivity;
@property (nonatomic, strong) NSError *userActivityError;
@property (nonatomic, copy) ALUserActivityRestorationHandler restorationHandler;

@end

typedef void (^ALWatchReplyHandler)(NSDictionary *replyInfo);

@interface ALWatchItem : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) ALWatchReplyHandler replyHandler;

@end

@interface ALAppDelegateItem : NSObject

@end
