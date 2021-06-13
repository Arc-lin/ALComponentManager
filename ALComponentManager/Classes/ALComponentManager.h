//
//  ALComponentManager.h
//  ALComponentManager
//
//  Created by Arclin on 2020/3/2.
//

#import <Foundation/Foundation.h>

#import "ALComponentProtocol.h"
#import "ALContext.h"
#import "ALAppDelegate.h"
#import "ALModuleManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALComponentManager : NSObject

//save application global context
@property(nonatomic, strong) ALContext *context;

//@property (nonatomic, assign) BOOL enableException;

+ (instancetype)shareInstance;

+ (void)registerDynamicModule:(Class) moduleClass;

//- (id)createService:(Protocol *)proto;
//
////Registration is recommended to use a static way
//- (void)registerService:(Protocol *)proto service:(Class) serviceClass;

+ (void)triggerCustomEvent:(NSInteger)eventType;

@end

NS_ASSUME_NONNULL_END
