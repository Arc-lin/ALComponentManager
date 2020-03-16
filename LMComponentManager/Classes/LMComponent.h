//
//  LMComponent.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/16.
//

#import <Foundation/Foundation.h>
#import <LMContext.h>
#import "LMComponentManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMComponent : NSObject

//save application global context
@property(nonatomic, strong) LMContext *context;

@property (nonatomic, assign) BOOL enableException;

+ (instancetype)shareInstance;

+ (void)registerDynamicModule:(Class) moduleClass;

//- (id)createService:(Protocol *)proto;
//
////Registration is recommended to use a static way
//- (void)registerService:(Protocol *)proto service:(Class) serviceClass;

+ (void)triggerCustomEvent:(NSInteger)eventType;

@end

NS_ASSUME_NONNULL_END
