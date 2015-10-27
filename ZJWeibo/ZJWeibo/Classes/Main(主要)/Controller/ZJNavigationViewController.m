//
//  ZJNavigationViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJNavigationViewController.h"


@interface ZJNavigationViewController ()

@end

@implementation ZJNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

/**
 *  拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    NSLog(@"%@--%d",viewController,self.viewControllers.count);
    
#warning 注意位置
    //除了栈底子控制器，其他push进来的子控制器都要隐藏tabBar
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置所有push进来的子控制器的导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_back" highImage:@"navigationbar_back_highlighted" target:self action:@selector(back)];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_more" highImage:@"navigationbar_more_highlighted" target:self action:@selector(more)];
    }
    
    [super pushViewController:viewController animated:animated];
    
   
}

#pragma mark - 点击事件
- (void)back
{
 
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}



@end
