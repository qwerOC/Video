//
//  AppDelegate.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/11/25.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "HostMuTabbarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _tabbarVC=[[HostMuTabbarController  alloc] init];
    self.window.rootViewController=_tabbarVC;
    [self.window makeKeyAndVisible];
    //设置导航条文字颜色 白色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置按钮文字颜色 白色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    return YES;
}


@end
