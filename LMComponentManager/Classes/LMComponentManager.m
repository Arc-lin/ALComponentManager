//
//  LMComponentManager.m
//  LMComponentManager
//
//  Created by Arclin on 2020/3/2.
//

#import "LMComponentManager.h"

@interface LMComponentManager()

@end

@implementation LMComponentManager

+ (instancetype)shareInstance
{
    static dispatch_once_t p;
    static id instance = nil;
    
    dispatch_once(&p, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (void)registerDynamicModule:(Class)moduleClass
{
    [[LMModuleManager sharedManager] registerDynamicModule:moduleClass];
}

//- (id)createService:(Protocol *)proto;
//{
//    return [[BHServiceManager sharedManager] createService:proto];
//}

//- (void)registerService:(Protocol *)proto service:(Class) serviceClass
//{
//    [[BHServiceManager sharedManager] registerService:proto implClass:serviceClass];
//}
    
+ (void)triggerCustomEvent:(NSInteger)eventType
{
    if(eventType < 1000) {
        return;
    }
    
    [[LMModuleManager sharedManager] triggerEvent:eventType];
}

#pragma mark - Private

-(void)setContext:(LMContext *)context
{
    _context = context;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self loadStaticServices];
        [self loadStaticModules];
    });
}


- (void)loadStaticModules
{
//    [[LMComponentManager sharedManager] loadLocalModules];
    
    [[LMModuleManager sharedManager] registedAllModules];
}

//-(void)loadStaticServices
//{
//    [BHServiceManager sharedManager].enableException = self.enableException;
//
//    [[BHServiceManager sharedManager] registerLocalServices];
//
//}

@end
