//
//  AppDelegate.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/10/16.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "AppDelegate.h"
#import "ZJTabBarViewController.h"
#import "ZJOAuthViewController.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import <SDWebImageManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    application.statusBarHidden = NO;
    
    //1.创建主窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;

    
    //2.设置根控制器
    //取出账号信息
    ZJAccount *account = [ZJAccountTool account];
    if (account) {//之前登陆过，直接进入tabBar控制器
        ZJTabBarViewController *tabBarVC = [[ZJTabBarViewController alloc] init];
        self.window.rootViewController = tabBarVC;
    }else{//进入授权控制器
        self.window.rootViewController = [[ZJOAuthViewController alloc] init];
    }
    
    //3.让主窗口显示
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  当app进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    /*
     APP的状态：
     1.死亡状态：APP没打开
     2.前台运行状态
     3.后台暂停状态：停止一切动画、定时器、多媒体操作，很难再做其他操作
     4.后台运行状态
     */
    
    //向系统申请后台运行的资格，能维持多久，是不确定的
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        //当所申请后台运行时间已经过期，就会调用这个block
        
        //赶紧结束任务
        [application endBackgroundTask:task];
    }];
    
    /*
     1.定义变量UIBackgroundTaskIdentifier task
     2.执行右边的代码（这时候task没有值）
     [application beginBackgroundTaskWithExpirationHandler:^{
     //当申请的后台运行时间已经结束（过期），就会调用这个block
     
     //赶紧结束任务
     [application endBackgroundTask:task];
     }];
     3.将右边方法的返回值赋值给task
     */

    //如何保证应用在后台长时间运行：
    //在Info.plist 文件设置后台模式
    //搞一个0kb的MP3文件，没有声音
    //循环播放
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  清除内存中的从网络上加载微博数据时产生的所有图片
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //单例对象
    SDWebImageManager *magager = [SDWebImageManager sharedManager];
    
    //1.取消下载
    [magager cancelAll];
    
    //2.清除内存中的所有图片缓存
    [magager.imageCache clearMemory];
    
}
@end
