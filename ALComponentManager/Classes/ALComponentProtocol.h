//
//  ALComponentProtocol.h
//  ALComponentManager
//
//  Created by Arclin on 2020/3/13.
//

#ifndef ALComponentProtocol_h
#define ALComponentProtocol_h
#import "ALAnnotation.h"

@class ALContext;

@protocol ALComponentProtocol <NSObject>


@optional

//如果不去设置Level默认是Normal
- (void)basicModuleLevel;
//越大越优先
- (NSInteger)modulePriority;

- (BOOL)async;

- (void)modSetUp:(ALContext *)context;

- (void)modInit:(ALContext *)context;

- (void)modSplash:(ALContext *)context;

- (void)modQuickAction:(ALContext *)context;

- (void)modTearDown:(ALContext *)context;

- (void)modWillResignActive:(ALContext *)context;

- (void)modDidEnterBackground:(ALContext *)context;

- (void)modWillEnterForeground:(ALContext *)context;

- (void)modDidBecomeActive:(ALContext *)context;

- (void)modWillTerminate:(ALContext *)context;

- (void)modUnmount:(ALContext *)context;

- (void)modOpenURL:(ALContext *)context;

- (void)modDidReceiveMemoryWaring:(ALContext *)context;

- (void)modDidFailToRegisterForRemoteNotifications:(ALContext *)context;

- (void)modDidRegisterForRemoteNotifications:(ALContext *)context;

- (void)modDidReceiveRemoteNotification:(ALContext *)context;

- (void)modDidReceiveLocalNotification:(ALContext *)context;

- (void)modWillPresentNotification:(ALContext *)context;

- (void)modDidReceiveNotificationResponse:(ALContext *)context;

- (void)modWillContinueUserActivity:(ALContext *)context;

- (void)modContinueUserActivity:(ALContext *)context;

- (void)modDidFailToContinueUserActivity:(ALContext *)context;

- (void)modDidUpdateContinueUserActivity:(ALContext *)context;

- (void)modHandleWatchKitExtensionRequest:(ALContext *)context;

- (void)modDidCustomEvent:(ALContext *)context;
@end


#endif /* ALComponentProtocol_h */
