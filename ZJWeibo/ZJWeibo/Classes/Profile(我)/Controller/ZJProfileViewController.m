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
#import "ZJProfileHeaderView.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import <MJExtension.h>
#import "ZJInfoCount.h"
#import "ZJInfoCountTool.h"
#import "ZJProfileHeaderBottomView.h"
#import "ZJFriendsInfoViewController.h"
#import "ZJFollowersInfoViewController.h"


@interface ZJProfileViewController ()<ZJProfileHeaderViewDelegate>

@property(nonatomic,weak) ZJInfoCount *infoCount;
@property(nonatomic,weak) ZJProfileHeaderView *headerView;


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
    
    //设置tableHeaderView
    [self setupHeaderView];
    
    //获取用户信息
    [self setupUserInfo];
    
    //bottomView按钮被点击的通知
    [ZJNotificationCenter addObserver:self selector:@selector(bottomViewBtnDidSelect:) name:ZJProfileHeaderBottomViewBtnDidSelectNotification object:nil];
    
}

/**
 *  移除观察者
 */
- (void)dealloc
{
    [ZJNotificationCenter removeObserver:self];
}

#pragma mark - init method
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //设置headerView
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
/**
 *  设置tableHeaderView
 */
- (void)setupHeaderView
{
    ZJAccount *acount = [ZJAccountTool account];
    ZJProfileHeaderView *headerView = [[ZJProfileHeaderView alloc] init];
    headerView.account = acount;//将账号模型数据传给ZJProfileHeaderView
    headerView.frame = CGRectMake(0, 0, self.view.width, 100);
    headerView.delegate = self;//设置代理
    self.tableView.tableHeaderView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(ZJCellMargin, 0, 0, 0);
    self.headerView = headerView;
}
/**
 *  获取用户信息
 */
- (void)setupUserInfo
{
    /*
     https://api.weibo.com/2/users/show.json
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户ID。
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取得模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
//        ZJLog(@"请求成功--%@",json);
        ////通过MJExtension字典转模型
        ZJInfoCount *infoCount = [ZJInfoCount objectWithKeyValues:json];
        self.headerView.infoCount = infoCount;
        [ZJInfoCountTool saveInfoCount:infoCount];
        
    } failure:^(NSError *error) {
        ZJLog(@"请求失败--%@",error);
    }];

}

#pragma mark - action method
- (void)setting
{
    //    ZJLog(@"setting");
    ZJSettingViewController *settingVc = [[ZJSettingViewController alloc] init];
    settingVc.title = @"设置";
    [self.navigationController pushViewController:settingVc animated:YES];
}
/**
 *  bottomView按钮被点击的通知
 */
- (void)bottomViewBtnDidSelect:(NSNotification *)notification
{
    //取出携带的按钮类型
    UIButton *btn = notification.userInfo[ZJSelectProfileHeaderBottomViewBtnType];
//    ZJLog(@"%d",btn.tag);
    switch (btn.tag) {
        case ZJProfileHeaderBottomViewButtonStatusesType:
            ZJLog(@"---微博");
            break;
        case ZJProfileHeaderBottomViewButtonFriendsType:
//            ZJLog(@"---关注");
            [self setupFriendsInfoVc];
            break;
        case ZJProfileHeaderBottomViewButtonFollowersType:
//            ZJLog(@"---粉丝");
            [self setupFollowersInfoVc];
            break;
    }
    
}

#pragma mark - custom method
/**
 *  跳转到关注详情控制器
 */
- (void)setupFriendsInfoVc
{
    ZJFriendsInfoViewController *friendsVc = [[ZJFriendsInfoViewController alloc] init];
    [self.navigationController pushViewController:friendsVc animated:YES];
}
/**
 *  跳转到粉丝详情控制器
 */
- (void)setupFollowersInfoVc
{
    ZJFollowersInfoViewController *followersVc = [[ZJFollowersInfoViewController alloc] init];
    [self.navigationController pushViewController:followersVc animated:YES];
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return ZJCellMargin + 3;
    }
    return 0.0;
}

#pragma mark - ZJProfileHeaderViewDelegate
- (void)profileHeaderView:(ZJProfileHeaderView *)profileHeaderView
{
//    ZJLog(@"ZJProfileViewController---profileHeaderView");
    //1.创建storyboard对象
    UIStoryboard *profileDetail = [UIStoryboard storyboardWithName:@"ZJProfileDetail" bundle:nil];
    //2.创建storyboard对应的控制器
    UIViewController *profileDetailVc = profileDetail.instantiateInitialViewController;
    //3.以push的方式跳转
    [self.navigationController pushViewController:profileDetailVc animated:YES];
    
}




@end
