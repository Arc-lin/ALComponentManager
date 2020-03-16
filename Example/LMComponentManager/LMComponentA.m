//
//  LMComponentA.m
//  LMComponentManager_Example
//
//  Created by Arclin on 2020/3/16.
//  Copyright © 2020 arclin@dankal.cn. All rights reserved.
//

#import "LMComponentA.h"
#import <LMAnnotation.h>
#import <LMComponentManager.h>
#import <LMComponentProtocol.h>

@LMMod(LMComponentA);
@interface LMComponentA()<LMComponentProtocol>

@end

@implementation LMComponentA

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"ComponentA Init");
    }
    return self;
}

- (void)modSetUp:(LMContext *)context
{
    NSLog(@"ComponentA setup");
}

@end
