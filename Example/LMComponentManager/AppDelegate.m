//
//  LMAppDelegate.m
//  LMComponentManager
//
//  Created by arclin@dankal.cn on 02/28/2020.
//  Copyright (c) 2020 arclin@dankal.cn. All rights reserved.
//

#import "AppDelegate.h"
#import <LMContext.h>
#import <LMTimeProfiler.h>

#import "LMViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [LMContext shareInstance].application = application;
    [LMContext shareInstance].launchOptions = launchOptions;
    
//    [LMComponentManager shareInstance].enableException = YES;
    [[LMComponentManager shareInstance] setContext:[LMContext shareInstance]];
    [[LMTimeProfiler sharedTimeProfiler] recordEventTime:@"BeeHive::super start launch"];

    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    

    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[LMViewController new]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

@end

