//
//  ALComponentManager.m
//  ALComponentManager
//
//  Created by Arclin on 2020/3/2.
//

#import "ALComponentManager.h"

@interface ALComponentManager()

@end

@implementation ALComponentManager

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
    [[ALModuleManager sharedManager] registerDynamicModule:moduleClass];
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
    
    [[ALModuleManager sharedManager] triggerEvent:eventType];
}

#pragma mark - Private

-(void)setContext:(ALContext *)context
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
//    [[ALComponentManager sharedManager] loadLocalModules];
    
    [[ALModuleManager sharedManager] registedAllModules];
}

//-(void)loadStaticServices
//{
//    [BHServiceManager sharedManager].enableException = self.enableException;
//
//    [[BHServiceManager sharedManager] registerLocalServices];
//
//}

@end
