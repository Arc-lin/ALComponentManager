//
//  LMContext.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/15.
//

#import <Foundation/Foundation.h>
#import "LMAppDelegateItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LMEnvironmentType) {
    LMEnvironmentTypeDebug,
    LMEnvironmentTypeRelease,
};

@interface LMContext : NSObject

//global env
@property(nonatomic, assign) LMEnvironmentType env;

//global config
//@property(nonatomic, strong) BHConfig *config;

//application appkey
@property(nonatomic, strong) NSString *appkey;
//customEvent>=1000
@property(nonatomic, assign) NSInteger customEvent;

@property(nonatomic, strong) UIApplication *application;

@property(nonatomic, strong) NSDictionary *launchOptions;

@property(nonatomic, strong) NSString *moduleConfigName;

@property(nonatomic, strong) NSString *serviceConfigName;

//3D-Touch model
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property (nonatomic, strong) LMShortcutItem *touchShortcutItem;
#endif

//OpenURL model
@property (nonatomic, strong) LMOpenURLItem *openURLItem;

//Notifications Remote or Local
@property (nonatomic, strong) LMNotificationsItem *notificationsItem;

//user Activity Model
@property (nonatomic, strong) LMUserActivityItem *userActivityItem;

//watch Model
@property (nonatomic, strong) LMWatchItem *watchItem;

//custom param
@property (nonatomic, copy) NSDictionary *customParam;

+ (instancetype)shareInstance;

- (void)addServiceWithImplInstance:(id)implInstance serviceName:(NSString *)serviceName;

- (void)removeServiceWithServiceName:(NSString *)serviceName;

- (id)getServiceInstanceFromServiceName:(NSString *)serviceName;

@end

NS_ASSUME_NONNULL_END
