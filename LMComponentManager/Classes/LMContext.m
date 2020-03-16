//
//  LMContext.m
//  LMComponentManager
//
//  Created by Arclin on 2020/3/15.
//

#import "LMContext.h"

@interface LMContext()

@property(nonatomic, strong) NSMutableDictionary *modulesByName;

@property(nonatomic, strong) NSMutableDictionary *servicesByName;

@end

@implementation LMContext

+ (instancetype)shareInstance
{
    static dispatch_once_t p;
    static id instance = nil;
    
    dispatch_once(&p, ^{
        instance = [[[self class] alloc] init];
        if ([instance isKindOfClass:[LMContext class]]) {
//            ((LMContext *) instance).config = [BHConfig shareInstance];
        }
    });
    
    return instance;
}

- (void)addServiceWithImplInstance:(id)implInstance serviceName:(NSString *)serviceName
{
    [[LMContext shareInstance].servicesByName setObject:implInstance forKey:serviceName];
}

- (void)removeServiceWithServiceName:(NSString *)serviceName
{
    [[LMContext shareInstance].servicesByName removeObjectForKey:serviceName];
}

- (id)getServiceInstanceFromServiceName:(NSString *)serviceName
{
    return [[LMContext shareInstance].servicesByName objectForKey:serviceName];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modulesByName  = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.servicesByName  = [[NSMutableDictionary alloc] initWithCapacity:1];
//        self.moduleConfigName = @"BeeHive.bundle/BeeHive";
//        self.serviceConfigName = @"BeeHive.bundle/BHService";
      
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
        self.touchShortcutItem = [LMShortcutItem new];
#endif

        self.openURLItem = [LMOpenURLItem new];
        self.notificationsItem = [LMNotificationsItem new];
        self.userActivityItem = [LMUserActivityItem new];
    }

    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    LMContext *context = [[self.class allocWithZone:zone] init];
    
    context.env = self.env;
//    context.config = self.config;
    context.appkey = self.appkey;
    context.customEvent = self.customEvent;
    context.application = self.application;
    context.launchOptions = self.launchOptions;
    context.moduleConfigName = self.moduleConfigName;
    context.serviceConfigName = self.serviceConfigName;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
    context.touchShortcutItem = self.touchShortcutItem;
#endif
    context.openURLItem = self.openURLItem;
    context.notificationsItem = self.notificationsItem;
    context.userActivityItem = self.userActivityItem;
    context.customParam = self.customParam;
    
    return context;
}

@end
