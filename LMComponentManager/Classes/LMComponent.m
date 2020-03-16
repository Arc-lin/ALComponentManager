//
//  LMComponent.m
//  LMComponentManager
//
//  Created by Arclin on 2020/3/16.
//

#import "LMComponent.h"

@implementation LMComponent

#pragma mark - public

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
    [[LMComponentManager sharedManager] registerDynamicModule:moduleClass];
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
    
    [[LMComponentManager sharedManager] triggerEvent:eventType];
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
    
    [[LMComponentManager sharedManager] registedAllModules];
    
}

//-(void)loadStaticServices
//{
//    [BHServiceManager sharedManager].enableException = self.enableException;
//    
//    [[BHServiceManager sharedManager] registerLocalServices];
//    
//}

@end
