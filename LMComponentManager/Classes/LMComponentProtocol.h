//
//  LMComponentProtocol.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/13.
//

#ifndef LMComponentProtocol_h
#define LMComponentProtocol_h

@class LMContext;

@protocol LMComponentProtocol <NSObject>


@optional

//如果不去设置Level默认是Normal
- (void)basicModuleLevel;
//越大越优先
- (NSInteger)modulePriority;

- (BOOL)async;

- (void)modSetUp:(LMContext *)context;

- (void)modInit:(LMContext *)context;

- (void)modSplash:(LMContext *)context;

- (void)modQuickAction:(LMContext *)context;

- (void)modTearDown:(LMContext *)context;

- (void)modWillResignActive:(LMContext *)context;

- (void)modDidEnterBackground:(LMContext *)context;

- (void)modWillEnterForeground:(LMContext *)context;

- (void)modDidBecomeActive:(LMContext *)context;

- (void)modWillTerminate:(LMContext *)context;

- (void)modUnmount:(LMContext *)context;

- (void)modOpenURL:(LMContext *)context;

- (void)modDidReceiveMemoryWaring:(LMContext *)context;

- (void)modDidFailToRegisterForRemoteNotifications:(LMContext *)context;

- (void)modDidRegisterForRemoteNotifications:(LMContext *)context;

- (void)modDidReceiveRemoteNotification:(LMContext *)context;

- (void)modDidReceiveLocalNotification:(LMContext *)context;

- (void)modWillPresentNotification:(LMContext *)context;

- (void)modDidReceiveNotificationResponse:(LMContext *)context;

- (void)modWillContinueUserActivity:(LMContext *)context;

- (void)modContinueUserActivity:(LMContext *)context;

- (void)modDidFailToContinueUserActivity:(LMContext *)context;

- (void)modDidUpdateContinueUserActivity:(LMContext *)context;

- (void)modHandleWatchKitExtensionRequest:(LMContext *)context;

- (void)modDidCustomEvent:(LMContext *)context;
@end


#endif /* LMComponentProtocol_h */
