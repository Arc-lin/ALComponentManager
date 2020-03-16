//
//  LMComponentManager.m
//  LMComponentManager
//
//  Created by Arclin on 2020/3/2.
//

#import "LMComponentManager.h"
#import "LMComponentProtocol.h"
#import "LMContext.h"
#import "LMTimeProfiler.h"

#define kModuleArrayKey     @"moduleClasses"
#define kModuleInfoNameKey  @"moduleClass"
#define kModuleInfoLevelKey @"moduleLevel"
#define kModuleInfoPriorityKey @"modulePriority"
#define kModuleInfoHasInstantiatedKey @"moduleHasInstantiated"

static  NSString *kSetupSelector = @"modSetUp:";
static  NSString *kInitSelector = @"modInit:";
static  NSString *kSplashSeletor = @"modSplash:";
static  NSString *kTearDownSelector = @"modTearDown:";
static  NSString *kWillResignActiveSelector = @"modWillResignActive:";
static  NSString *kDidEnterBackgroundSelector = @"modDidEnterBackground:";
static  NSString *kWillEnterForegroundSelector = @"modWillEnterForeground:";
static  NSString *kDidBecomeActiveSelector = @"modDidBecomeActive:";
static  NSString *kWillTerminateSelector = @"modWillTerminate:";
static  NSString *kUnmountEventSelector = @"modUnmount:";
static  NSString *kQuickActionSelector = @"modQuickAction:";
static  NSString *kOpenURLSelector = @"modOpenURL:";
static  NSString *kDidReceiveMemoryWarningSelector = @"modDidReceiveMemoryWaring:";
static  NSString *kFailToRegisterForRemoteNotificationsSelector = @"modDidFailToRegisterForRemoteNotifications:";
static  NSString *kDidRegisterForRemoteNotificationsSelector = @"modDidRegisterForRemoteNotifications:";
static  NSString *kDidReceiveRemoteNotificationsSelector = @"modDidReceiveRemoteNotification:";
static  NSString *kDidReceiveLocalNotificationsSelector = @"modDidReceiveLocalNotification:";
static  NSString *kWillPresentNotificationSelector = @"modWillPresentNotification:";
static  NSString *kDidReceiveNotificationResponseSelector = @"modDidReceiveNotificationResponse:";
static  NSString *kWillContinueUserActivitySelector = @"modWillContinueUserActivity:";
static  NSString *kContinueUserActivitySelector = @"modContinueUserActivity:";
static  NSString *kDidUpdateContinueUserActivitySelector = @"modDidUpdateContinueUserActivity:";
static  NSString *kFailToContinueUserActivitySelector = @"modDidFailToContinueUserActivity:";
static  NSString *kHandleWatchKitExtensionRequestSelector = @"modHandleWatchKitExtensionRequest:";
static  NSString *kAppCustomSelector = @"modDidCustomEvent:";

@interface LMComponentManager()

@property(nonatomic, strong) NSMutableArray     *moduleDynamicClasses;

@property(nonatomic, strong) NSMutableArray<NSDictionary *>     *moduleInfos;
@property(nonatomic, strong) NSMutableArray     *modules;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<id<LMComponentProtocol>> *> *modulesByEvent;
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *selectorByEvent;

@end

@implementation LMComponentManager

#pragma mark - public

+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[LMComponentManager alloc] init];
    });
    return sharedManager;
}

- (void)registerDynamicModule:(Class)moduleClass
{
    [self registerDynamicModule:moduleClass shouldTriggerInitEvent:NO];
}

- (void)registerDynamicModule:(Class)moduleClass
       shouldTriggerInitEvent:(BOOL)shouldTriggerInitEvent
{
    [self addModuleFromObject:moduleClass shouldTriggerInitEvent:shouldTriggerInitEvent];
}

- (void)unRegisterDynamicModule:(Class)moduleClass {
    if (!moduleClass) {
        return;
    }
    [self.moduleInfos filterUsingPredicate:[NSPredicate predicateWithFormat:@"%@!=%@", kModuleInfoNameKey, NSStringFromClass(moduleClass)]];
    __block NSInteger index = -1;
    [self.modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:moduleClass]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0) {
        [self.modules removeObjectAtIndex:index];
    }
    [self.modulesByEvent enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<id<LMComponentProtocol>> * _Nonnull obj, BOOL * _Nonnull stop) {
        __block NSInteger index = -1;
        [obj enumerateObjectsUsingBlock:^(id<LMComponentProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:moduleClass]) {
                index = idx;
                *stop = NO;
            }
        }];
        if (index >= 0) {
            [obj removeObjectAtIndex:index];
        }
    }];
}

- (void)registedAllModules
{

    [self.moduleInfos sortUsingComparator:^NSComparisonResult(NSDictionary *module1, NSDictionary *module2) {
        NSNumber *module1Level = (NSNumber *)[module1 objectForKey:kModuleInfoLevelKey];
        NSNumber *module2Level =  (NSNumber *)[module2 objectForKey:kModuleInfoLevelKey];
        if (module1Level.integerValue != module2Level.integerValue) {
            return module1Level.integerValue > module2Level.integerValue;
        } else {
            NSNumber *module1Priority = (NSNumber *)[module1 objectForKey:kModuleInfoPriorityKey];
            NSNumber *module2Priority = (NSNumber *)[module2 objectForKey:kModuleInfoPriorityKey];
            return module1Priority.integerValue < module2Priority.integerValue;
        }
    }];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    //module init
    [self.moduleInfos enumerateObjectsUsingBlock:^(NSDictionary *module, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *classStr = [module objectForKey:kModuleInfoNameKey];
        
        Class moduleClass = NSClassFromString(classStr);
        BOOL hasInstantiated = ((NSNumber *)[module objectForKey:kModuleInfoHasInstantiatedKey]).boolValue;
        if (NSStringFromClass(moduleClass) && !hasInstantiated) {
            id<LMComponentProtocol> moduleInstance = [[moduleClass alloc] init];
            [tmpArray addObject:moduleInstance];
        }
        
    }];
    
//    [self.LModules removeAllObjects];

    [self.modules addObjectsFromArray:tmpArray];
    
    [self registerAllSystemEvents];
}

- (void)registerCustomEvent:(NSInteger)eventType
   withModuleInstance:(id)moduleInstance
       andSelectorStr:(NSString *)selectorStr {
    if (eventType < 1000) {
        return;
    }
    [self registerEvent:eventType withModuleInstance:moduleInstance andSelectorStr:selectorStr];
}

- (void)triggerEvent:(NSInteger)eventType
{
    [self triggerEvent:eventType withCustomParam:nil];
    
}

- (void)triggerEvent:(NSInteger)eventType
     withCustomParam:(NSDictionary *)customParam {
    [self handleModuleEvent:eventType forTarget:nil withCustomParam:customParam];
}


#pragma mark - life loop

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moduleDynamicClasses = [NSMutableArray array];
    }
    return self;
}


#pragma mark - private

- (LMComponentLevel)checkModuleLevel:(NSUInteger)level
{
    switch (level) {
        case 0:
            return LMComponentBasic;
            break;
        case 1:
            return LMComponentNormal;
            break;
        default:
            break;
    }
    //default normal
    return LMComponentNormal;
}


- (void)addModuleFromObject:(id)object
     shouldTriggerInitEvent:(BOOL)shouldTriggerInitEvent
{
    Class class;
    NSString *moduleName = nil;
    
    if (object) {
        class = object;
        moduleName = NSStringFromClass(class);
    } else {
        return ;
    }
    
    __block BOOL flag = YES;
    [self.modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:class]) {
            flag = NO;
            *stop = YES;
        }
    }];
    if (!flag) {
        return;
    }
    
    if ([class conformsToProtocol:@protocol(LMComponentProtocol)]) {
        NSMutableDictionary *moduleInfo = [NSMutableDictionary dictionary];
        
        BOOL responseBasicLevel = [class instancesRespondToSelector:@selector(basicModuleLevel)];

        int levelInt = 1;
        
        if (responseBasicLevel) {
            levelInt = 0;
        }
        
        [moduleInfo setObject:@(levelInt) forKey:kModuleInfoLevelKey];
        if (moduleName) {
            [moduleInfo setObject:moduleName forKey:kModuleInfoNameKey];
        }

        [self.moduleInfos addObject:moduleInfo];
        
        id<LMComponentProtocol> moduleInstance = [[class alloc] init];
        [self.modules addObject:moduleInstance];
        [moduleInfo setObject:@(YES) forKey:kModuleInfoHasInstantiatedKey];
        [self.modules sortUsingComparator:^NSComparisonResult(id<LMComponentProtocol> moduleInstance1, id<LMComponentProtocol> moduleInstance2) {
            NSNumber *module1Level = @(LMComponentNormal);
            NSNumber *module2Level = @(LMComponentNormal);
            if ([moduleInstance1 respondsToSelector:@selector(basicModuleLevel)]) {
                module1Level = @(LMComponentBasic);
            }
            if ([moduleInstance2 respondsToSelector:@selector(basicModuleLevel)]) {
                module2Level = @(LMComponentBasic);
            }
            if (module1Level.integerValue != module2Level.integerValue) {
                return module1Level.integerValue > module2Level.integerValue;
            } else {
                NSInteger module1Priority = 0;
                NSInteger module2Priority = 0;
                if ([moduleInstance1 respondsToSelector:@selector(modulePriority)]) {
                    module1Priority = [moduleInstance1 modulePriority];
                }
                if ([moduleInstance2 respondsToSelector:@selector(modulePriority)]) {
                    module2Priority = [moduleInstance2 modulePriority];
                }
                return module1Priority < module2Priority;
            }
        }];
        [self registerEventsByModuleInstance:moduleInstance];
        
        if (shouldTriggerInitEvent) {
            [self handleModuleEvent:LMSetupEvent forTarget:moduleInstance withSeletorStr:nil andCustomParam:nil];
            [self handleModulesInitEventForTarget:moduleInstance withCustomParam:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleModuleEvent:LMSplashEvent forTarget:moduleInstance withSeletorStr:nil andCustomParam:nil];
            });
        }
    }
}

- (void)registerAllSystemEvents
{
    [self.modules enumerateObjectsUsingBlock:^(id<LMComponentProtocol> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerEventsByModuleInstance:moduleInstance];
    }];
}

- (void)registerEventsByModuleInstance:(id<LMComponentProtocol>)moduleInstance
{
    NSArray<NSNumber *> *events = self.selectorByEvent.allKeys;
    [events enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerEvent:obj.integerValue withModuleInstance:moduleInstance andSelectorStr:self.selectorByEvent[obj]];
    }];
}

- (void)registerEvent:(NSInteger)eventType
         withModuleInstance:(id)moduleInstance
             andSelectorStr:(NSString *)selectorStr {
    SEL selector = NSSelectorFromString(selectorStr);
    if (!selector || ![moduleInstance respondsToSelector:selector]) {
        return;
    }
    NSNumber *eventTypeNumber = @(eventType);
    if (!self.selectorByEvent[eventTypeNumber]) {
        [self.selectorByEvent setObject:selectorStr forKey:eventTypeNumber];
    }
    if (!self.modulesByEvent[eventTypeNumber]) {
        [self.modulesByEvent setObject:@[].mutableCopy forKey:eventTypeNumber];
    }
    NSMutableArray *eventModules = [self.modulesByEvent objectForKey:eventTypeNumber];
    if (![eventModules containsObject:moduleInstance]) {
        [eventModules addObject:moduleInstance];
        [eventModules sortUsingComparator:^NSComparisonResult(id<LMComponentProtocol> moduleInstance1, id<LMComponentProtocol> moduleInstance2) {
            NSNumber *module1Level = @(LMComponentNormal);
            NSNumber *module2Level = @(LMComponentNormal);
            if ([moduleInstance1 respondsToSelector:@selector(basicModuleLevel)]) {
                module1Level = @(LMComponentBasic);
            }
            if ([moduleInstance2 respondsToSelector:@selector(basicModuleLevel)]) {
                module2Level = @(LMComponentBasic);
            }
            if (module1Level.integerValue != module2Level.integerValue) {
                return module1Level.integerValue > module2Level.integerValue;
            } else {
                NSInteger module1Priority = 0;
                NSInteger module2Priority = 0;
                if ([moduleInstance1 respondsToSelector:@selector(modulePriority)]) {
                    module1Priority = [moduleInstance1 modulePriority];
                }
                if ([moduleInstance2 respondsToSelector:@selector(modulePriority)]) {
                    module2Priority = [moduleInstance2 modulePriority];
                }
                return module1Priority < module2Priority;
            }
        }];
    }
}

#pragma mark - property setter or getter
- (NSMutableArray<NSDictionary *> *)moduleInfos {
    if (!_moduleInfos) {
        _moduleInfos = @[].mutableCopy;
    }
    return _moduleInfos;
}

- (NSMutableArray *)modules
{
    if (!_modules) {
        _modules = [NSMutableArray array];
    }
    return _modules;
}

- (NSMutableDictionary<NSNumber *, NSMutableArray<id<LMComponentProtocol>> *> *)modulesByEvent
{
    if (!_modulesByEvent) {
        _modulesByEvent = @{}.mutableCopy;
    }
    return _modulesByEvent;
}

- (NSMutableDictionary<NSNumber *,NSString *> *)selectorByEvent
{
    if (!_selectorByEvent) {
        _selectorByEvent = @{
                               @(LMSetupEvent):kSetupSelector,
                               @(LMInitEvent):kInitSelector,
//                               @(LMTearDownEvent):kTearDownSelector,
                               @(LMSplashEvent):kSplashSeletor,
                               @(LMWillResignActiveEvent):kWillResignActiveSelector,
                               @(LMDidEnterBackgroundEvent):kDidEnterBackgroundSelector,
                               @(LMWillEnterForegroundEvent):kWillEnterForegroundSelector,
                               @(LMDidBecomeActiveEvent):kDidBecomeActiveSelector,
                               @(LMWillTerminateEvent):kWillTerminateSelector,
                               @(LMUnmountEvent):kUnmountEventSelector,
                               @(LMOpenURLEvent):kOpenURLSelector,
                               @(LMDidReceiveMemoryWarningEvent):kDidReceiveMemoryWarningSelector,
                               
                               @(LMDidReceiveRemoteNotificationEvent):kDidReceiveRemoteNotificationsSelector,
                               @(LMWillPresentNotificationEvent):kWillPresentNotificationSelector,
                               @(LMDidReceiveNotificationResponseEvent):kDidReceiveNotificationResponseSelector,
                               
                               @(LMDidFailToRegisterForRemoteNotificationsEvent):kFailToRegisterForRemoteNotificationsSelector,
                               @(LMDidRegisterForRemoteNotificationsEvent):kDidRegisterForRemoteNotificationsSelector,
                               
                               @(LMDidReceiveLocalNotificationEvent):kDidReceiveLocalNotificationsSelector,
                               
                               @(LMWillContinueUserActivityEvent):kWillContinueUserActivitySelector,
                               
                               @(LMContinueUserActivityEvent):kContinueUserActivitySelector,
                               
                               @(LMDidFailToContinueUserActivityEvent):kFailToContinueUserActivitySelector,
                               
                               @(LMDidUpdateUserActivityEvent):kDidUpdateContinueUserActivitySelector,
                               
                               @(LMQuickActionEvent):kQuickActionSelector,
                               @(LMHandleWatchKitExtensionRequestEvent):kHandleWatchKitExtensionRequestSelector,
                               @(LMDidCustomEvent):kAppCustomSelector,
                               }.mutableCopy;
    }
    return _selectorByEvent;
}

#pragma mark - module protocol
- (void)handleModuleEvent:(NSInteger)eventType
                forTarget:(id<LMComponentProtocol>)target
          withCustomParam:(NSDictionary *)customParam
{
    switch (eventType) {
        case LMInitEvent:
            //special
            [self handleModulesInitEventForTarget:nil withCustomParam :customParam];
            break;
//        case LMTearDownEvent:
            //special
//            [self handleModulesTearDownEventForTarget:nil withCustomParam:customParam];
//            break;
        default: {
            NSString *selectorStr = [self.selectorByEvent objectForKey:@(eventType)];
            [self handleModuleEvent:eventType forTarget:nil withSeletorStr:selectorStr andCustomParam:customParam];
        }
            break;
    }
    
}

- (void)handleModulesInitEventForTarget:(id<LMComponentProtocol>)target
                        withCustomParam:(NSDictionary *)customParam
{
    LMContext *context = [LMContext shareInstance].copy;
    context.customParam = customParam;
    context.customEvent = LMInitEvent;
    
    NSArray<id<LMComponentProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    } else {
        moduleInstances = [self.modulesByEvent objectForKey:@(LMInitEvent)];
    }
    
    [moduleInstances enumerateObjectsUsingBlock:^(id<LMComponentProtocol> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(&*self) wself = self;
        void ( ^ bk )(void);
        bk = ^(){
            __strong typeof(&*self) sself = wself;
            if (sself) {
                if ([moduleInstance respondsToSelector:@selector(modInit:)]) {
                    [moduleInstance modInit:context];
                }
            }
        };

        [[LMTimeProfiler sharedTimeProfiler] recordEventTime:[NSString stringWithFormat:@"%@ --- modInit:", [moduleInstance class]]];
        
        if ([moduleInstance respondsToSelector:@selector(async)]) {
            BOOL async = [moduleInstance async];
            
            if (async) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    bk();
                });
                
            } else {
                bk();
            }
        } else {
            bk();
        }
    }];
}

//- (void)handleModulesTearDownEventForTarget:(id<LMComponentProtocol>)target
//                            withCustomParam:(NSDictionary *)customParam
//{
//    LMContext *context = [LMContext shareInstance].copy;
//    context.customParam = customParam;
////    context.customEvent = LMTearDownEvent;
//
//    NSArray<id<LMComponentProtocol>> *moduleInstances;
//    if (target) {
//        moduleInstances = @[target];
//    } else {
//        moduleInstances = [self.selectorByEvent objectForKey:@(LMTearDownEvent)];
//    }
//
//    //Reverse Order to unload
//    for (int i = (int)moduleInstances.count - 1; i >= 0; i--) {
//        id<LMComponentProtocol> moduleInstance = [moduleInstances objectAtIndex:i];
//        if (moduleInstance && [moduleInstance respondsToSelector:@selector(modTearDown:)]) {
//            [moduleInstance modTearDown:context];
//        }
//    }
//}

- (void)handleModuleEvent:(NSInteger)eventType
                forTarget:(id<LMComponentProtocol>)target
           withSeletorStr:(NSString *)selectorStr
           andCustomParam:(NSDictionary *)customParam
{
    LMContext *context = [LMContext shareInstance].copy;
    context.customParam = customParam;
    context.customEvent = eventType;
    if (!selectorStr.length) {
        selectorStr = [self.selectorByEvent objectForKey:@(eventType)];
    }
    SEL seletor = NSSelectorFromString(selectorStr);
    if (!seletor) {
        selectorStr = [self.selectorByEvent objectForKey:@(eventType)];
        seletor = NSSelectorFromString(selectorStr);
    }
    NSArray<id<LMComponentProtocol>> *moduleInstances;
    if (target) {
        moduleInstances = @[target];
    } else {
        moduleInstances = [self.modulesByEvent objectForKey:@(eventType)];
    }
    [moduleInstances enumerateObjectsUsingBlock:^(id<LMComponentProtocol> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([moduleInstance respondsToSelector:seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [moduleInstance performSelector:seletor withObject:context];
#pragma clang diagnostic pop
            
            [[LMTimeProfiler sharedTimeProfiler] recordEventTime:[NSString stringWithFormat:@"%@ --- %@", [moduleInstance class], NSStringFromSelector(seletor)]];
            
        }
    }];
}

@end
