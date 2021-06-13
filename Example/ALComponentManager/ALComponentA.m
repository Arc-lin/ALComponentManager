//
//  ALComponentA.m
//  ALComponentManager_Example
//
//  Created by Arclin on 2020/3/16.
//  Copyright © 2020 arclin@dankal.cn. All rights reserved.
//

#import "ALComponentA.h"
#import <ALAnnotation.h>
#import <ALComponentManager.h>
#import <ALComponentProtocol.h>

@ALMod(ALComponentA);
@interface ALComponentA()<ALComponentProtocol>

@end

@implementation ALComponentA

+ (void)load
{
    NSLog(@"Component A Load");    
}

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"ComponentA Init");
    }
    return self;
}

- (void)modSetUp:(ALContext *)context
{
    NSLog(@"Component A setup");
}

- (void)modDidBecomeActive:(ALContext *)context
{
    NSLog(@"Component A Become Active");
}

@end
