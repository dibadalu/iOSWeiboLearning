//
//  ZJTabBarViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJTabBarViewController.h"
#import "ZJHomeViewController.h"
#import "ZJMessageViewController.h"
#import "ZJDiscoverViewController.h"
#import "ZJProfileViewController.h"
#import "ZJNavigationViewController.h"


@interface ZJTabBarViewController ()

@end

@implementation ZJTabBarViewController

#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加子控制器

    //home
    ZJHomeViewController *home = [[ZJHomeViewController alloc] init];
    [self addOneChirdVC:home title:@"主页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    //message
//    ZJMessageViewController *message = [[ZJMessageViewController alloc] init];
//    [self addOneChirdVC:message title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    //discover
    ZJDiscoverViewController *discover = [[ZJDiscoverViewController alloc] init];
    [self addOneChirdVC:discover title:@"探索" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    //profile
    ZJProfileViewController *profile = [[ZJProfileViewController alloc] init];
    [self addOneChirdVC:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
}

#pragma mark - init method
- (void)addOneChirdVC:(UIViewController *)chirdVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //测试：背景色
//    chirdVC.view.backgroundColor = ZJRandomColor;
    
    //文字
    chirdVC.title = title;
    //图标
    chirdVC.tabBarItem.image = [UIImage imageNamed:image];
    //选中图标
    chirdVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    //将子控制器包装在UINavigationController中
    ZJNavigationViewController *nav = [[ZJNavigationViewController alloc] initWithRootViewController:chirdVC];
    [self addChildViewController:nav];
}




@end
