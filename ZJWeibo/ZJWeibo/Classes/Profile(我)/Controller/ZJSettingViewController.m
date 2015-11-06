//
//  ZJSettingViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJSettingViewController.h"
#import "ZJCommonItem.h"
#import "ZJCommonGroup.h"
#import "ZJCommonArrowItem.h"
#import "ZJCommonSwitchItem.h"
#import "ZJCommonLabelItem.h"
#import <SDImageCache.h>
#import "MBProgressHUD+MJ.h"


@implementation ZJSettingViewController
#pragma mark - system method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化模型数据
    [self setupGroups];
    
    //设置tableView的footer
    [self setupFooter];
}

#pragma mark - init method
/**
 *  设置tableView的footer
 */
- (void)setupFooter
{
    UIButton *footerBtn = [[UIButton alloc] init];
    
    //设置按钮文字
    [footerBtn setTitle:@"退出微博" forState:UIControlStateNormal];
    [footerBtn setTitleColor:ZJColor(250, 10, 10) forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //设置按钮的尺寸（不需要设置宽度，会自动平铺）
    footerBtn.height = 35;
    
    //设置按钮背景图片
    [footerBtn setBackgroundImage:[UIImage resizedImageName:@"common_card_background"] forState:UIControlStateNormal];
    [footerBtn setBackgroundImage:[UIImage resizedImageName:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    
    //监听按钮事件
    [footerBtn addTarget:self action:@selector(footerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = footerBtn;
}
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    
}
-(void)setupGroup0
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonArrowItem *account = [ZJCommonArrowItem itemWithTitle:@"账号管理"] ;
    group.items = @[account];
}
- (void)setupGroup1
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonArrowItem *notifications = [ZJCommonArrowItem itemWithTitle:@"通知"];
    ZJCommonArrowItem *privacyAndSecurity = [ZJCommonArrowItem itemWithTitle:@"隐私与安全"];
    ZJCommonArrowItem *defaultSetting = [ZJCommonArrowItem itemWithTitle:@"通用设置"];
    group.items = @[notifications,privacyAndSecurity,defaultSetting];
}

- (void)setupGroup2
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonArrowItem *feedBack = [ZJCommonArrowItem itemWithTitle:@"反馈"];
    ZJCommonArrowItem *about = [ZJCommonArrowItem itemWithTitle:@"关于微博"];
    group.items = @[feedBack,about];
}
- (void)setupGroup3
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonSwitchItem *night = [ZJCommonSwitchItem itemWithTitle:@"夜间模式"];
    ZJCommonLabelItem *cache = [ZJCommonLabelItem itemWithTitle:@"清除缓存"];
    //计算图片缓存的字节
    int byteSize = [SDImageCache sharedImageCache].getSize;
    double size = byteSize / 1000.0 /1000.0;//记得加.0
    cache.text = [NSString stringWithFormat:@"%.1fMB",size];
    
    __weak typeof(cache) weakCache = cache;
    __weak typeof(self) weakSettingVc = self;
    cache.operation = ^{//需要执行的操作：清除缓存
//        ZJLog(@"清除缓存");
        [MBProgressHUD showMessage:@"正在清除缓存中..."];
        
        //清除缓存
        [[SDImageCache sharedImageCache] cleanDisk];
        
        //文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        //缓存路径
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //移除所有文件/文件夹
        [mgr removeItemAtPath:caches error:nil];
        
        //设置item右边label为0.0MB
        weakCache.text = [NSString stringWithFormat:@"0.0MB"];
        
        //刷新表格
        [weakSettingVc.tableView reloadData];
        
        [MBProgressHUD hideHUD];
    };
    group.items = @[night,cache];
}

#pragma mark - action method 
- (void)footerBtnClick
{
    ZJLog(@"退出微博");
}
@end
