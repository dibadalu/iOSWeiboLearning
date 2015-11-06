//
//  ZJProfileViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileViewController.h"
#import "ZJCommonItem.h"
#import "ZJCommonGroup.h"
#import "ZJCommonArrowItem.h"
#import "ZJCommonSwitchItem.h"
#import "ZJCommonLabelItem.h"
#import "ZJSettingViewController.h"


@interface ZJProfileViewController ()

@end

@implementation ZJProfileViewController
#pragma mark - system method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化模型数据
    [self setupGroups];
    
    //navigationBar的设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];

}

#pragma mark - action method
- (void)setting
{
//    ZJLog(@"setting");
    ZJSettingViewController *settingVc = [[ZJSettingViewController alloc] init];
    settingVc.title = @"设置";
    [self.navigationController pushViewController:settingVc animated:YES];
}

#pragma mark - init method
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];

}
-(void)setupGroup0
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonArrowItem *newFriend = [ZJCommonArrowItem itemWithTitle:@"新的好友" icon:@"new_friend"];
    newFriend.badgeValue = @"50";
    group.items = @[newFriend];
}
- (void)setupGroup1
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    
    ZJCommonItem *album = [ZJCommonItem itemWithTitle:@"我的相册" icon:@"album"];
    album.subTitle = @"(80)";
    ZJCommonItem *collect = [ZJCommonItem itemWithTitle:@"我的收藏" icon:@"collect"];
    collect.subTitle = @"(50)";
    ZJCommonItem *like = [ZJCommonItem itemWithTitle:@"赞" icon:@"like"];
    like.subTitle = @"(182)";

    group.items = @[album,collect,like];
}


@end
