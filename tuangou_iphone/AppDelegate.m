//
//  AppDelegate.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/28.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property(nonatomic,strong)Reachability* hostReach;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self checkNetwork];
    
    
    //注册Parse
    [Parse setApplicationId:@"sCwFBPUvKc8kYj5fUlymFuAMQr0i8a7XU1AfInRi"
                  clientKey:@"uOqaQENeJ1DywGksV0T8gXUYN0MOB1yrjjeS1G77"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //注册高德地图sdk
    [AMapLocationServices sharedServices].apiKey = @"d2e122617ba5dbdda1ffe52ef3353ffc";
    [AMapNaviServices sharedServices].apiKey = @"d2e122617ba5dbdda1ffe52ef3353ffc";
    [MAMapServices sharedServices].apiKey = @"d2e122617ba5dbdda1ffe52ef3353ffc";
    return YES;
}
#pragma mark - 检查网络
-(void)checkNetwork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_hostReach startNotifier];
}
-(void)reachabilityChanged:(NSNotification*)noti{
    Reachability* curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"没网");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请检查你的网络是否异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if(status == ReachableViaWiFi){
        NSLog(@"有网");
    }else if(status == ReachableViaWWAN){
        NSLog(@"有网");
    }else{
        NSLog(@"没网");
    }

    
}
- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
