//
//  ALComponentB.m
//  ALComponentManager_Example
//
//  Created by Arclin on 2020/3/16.
//  Copyright © 2020 arclin@dankal.cn. All rights reserved.
//

#import "ALComponentB.h"
#import <ALAnnotation.h>
#import <ALComponentManager.h>
#import <ALComponentProtocol.h>

@ALMod(ALComponentB);
@interface ALComponentB()<ALComponentProtocol>

@end

@implementation ALComponentB

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

- (void)modSetUp:(ALContext *)context
{
    NSLog(@"ComponentB setup");
}

@end
