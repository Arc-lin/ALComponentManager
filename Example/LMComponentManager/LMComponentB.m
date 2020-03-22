//
//  LMComponentB.m
//  LMComponentManager_Example
//
//  Created by Arclin on 2020/3/16.
//  Copyright © 2020 arclin@dankal.cn. All rights reserved.
//

#import "LMComponentB.h"
#import <LMAnnotation.h>
#import <LMComponentManager.h>
#import <LMComponentProtocol.h>

@LMMod(LMComponentB);
@interface LMComponentB()<LMComponentProtocol>

@end

@implementation LMComponentB

+ (void)load
{
    NSLog(@"Component B Load");
}

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"ComponentB Init");
    }
    return self;
}

- (void)modSetUp:(LMContext *)context
{
    NSLog(@"ComponentB setup");
}

@end
