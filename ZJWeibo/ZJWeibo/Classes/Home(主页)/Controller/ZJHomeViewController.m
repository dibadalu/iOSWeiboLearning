//
//  ZJHomeViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJHomeViewController.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJUser.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "ZJStatus.h"
#import <MJRefresh.h>
#import "ZJStatusCell.h"
#import "ZJStatusFrame.h"
#import "ZJComposeViewController.h"
#import "ZJStatusTool.h"

@interface ZJHomeViewController ()

/** 微博模型数组（存放ZJStatus模型一个模型代表一条微博） 可变数组*/
//@property(nonatomic,strong) NSMutableArray *statuses;
/** 微博Frame模型数组（存放ZJStatusFrame模型，一个模型代表一条微博）*/
@property(nonatomic,strong) NSMutableArray *statusFrames;

@end

@implementation ZJHomeViewController
/**
 *  微博Frame模型数组的懒加载
 */
- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setupNav];
    
    //获得用户信息
    [self setupUserInfo];
    
    //集成下拉刷新加载最新微博数据
    [self setupDownRefresh];
    
    //集成上拉刷新加载更多微博数据
    [self setupUpRefresh];
    
    //显示微博未读数(定时器,每隔60调用一次)
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    //将timer放进NSRunLoop,让主线程能够及时处理
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark - 初始化方法
/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    //设置导航栏按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted" target:self action:@selector(popClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_compose" highImage:@"navigationbar_compose_highlighted" target:self action:@selector(compose)];
    
    //设置标题按钮
    UIButton *titleBtn = [[UIButton alloc] init];
    titleBtn.frame = CGRectMake(0, 0, 200, 35);
    NSString *name = [ZJAccountTool account].name;//取得模型
    //设置文字
    [titleBtn setTitle:name?name:@"主页" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //监听按钮点击
    [titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}
/**
 *  获得用户信息
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
        //获得标题按钮
        UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
        //通过MJExtension字典转模型
        ZJUser *user = [ZJUser objectWithKeyValues:json];
        [titleBtn setTitle:user.name forState:UIControlStateNormal];
        
        //将昵称存储到沙盒
        account.name = user.name;
        [ZJAccountTool saveAccount:account];
    } failure:^(NSError *error) {
        ZJLog(@"请求失败--%@",error);
    }];
    
}

/**
 *  加载最新的微博数据
 */
- (void)loadNewsStatus
{

    /*
     https://api.weibo.com/2/statuses/friends_timeline.json
     请求参数：
     access_token false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得
     since_id	  false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	      false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	      false	int	    单页返回的记录条数，最大不超过100，默认为20。
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
//    params[@"count"] = @5;//默认是20
    
    //取出最新的微博
    ZJStatusFrame *firstStatusFrame = [self.statusFrames firstObject];
    if (firstStatusFrame) {
        //若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        params[@"since_id"] = firstStatusFrame.status.idstr;
    }
    
    //通过block（局部函数）的方式，处理微博数据（微博字典数组）
    void(^dealingResult)(NSArray *) = ^(NSArray *statuses){
        
        //取得微博字典数组，字典转模型(微博字典数组->微博模型数组)
        NSArray *newStatuses = [ZJStatus objectArrayWithKeyValuesArray:statuses];
        
        //将ZJStatus转化为ZJStatusFrame
        NSArray *frames = [self statusFramesWithStatuses:newStatuses];
        
        //将最新的微博数据，添加到总数组的最前面(插入)
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:frames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [self.tableView.header endRefreshing];
        
        //显示最新微博的数量
        [self showNewStatusesCount:newStatuses.count];
    };
    
    //2.根据请求参数从沙盒中加载FMDB缓存的微博数据（微博字典数组）
    NSArray *statuses = [ZJStatusTool statusesWithParams:params];
    if (statuses.count) {//数据库有数据
        
        dealingResult(statuses);
       
    }else{
        //3.发送请求
        [ZJHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            //        ZJLog(@"请求成功---%@",json[@"statuses"]);
            
            //FMDB缓存从新浪获取的微博字典数组
            [ZJStatusTool saveStatuses:json[@"statuses"]];
            
            dealingResult(json[@"statuses"]);
            
        } failure:^(NSError *error) {
            ZJLog(@"请求失败---%@",error);
            
            //结束下拉刷新
            [self.tableView.header endRefreshing];
        }];

    }
    
}
/**
 *  集成下拉刷新加载最新微博数据
 */
- (void)setupDownRefresh
{
    //1.添加下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewsStatus)];
    
    //2.进入刷新状态
    [self.tableView.header beginRefreshing];

}
/**
 *  显示最新微博的数量
 */
- (void)showNewStatusesCount:(NSUInteger)count
{
    //0.清空微博未读数
    self.tabBarItem.badgeValue = nil;
    
    //1.创建一个label显示最新微博数量
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor orangeColor];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    //设置label的其他属性（最新微博数量）
    if (count == 0) {
        label.text = @"没有新微博";
    }else{
        label.text = [NSString stringWithFormat:@"%d新微博",count];
    }
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:16]];
    label.textAlignment = NSTextAlignmentCenter;
    
    //2.将label添加到导航栏控制器的view上，并且在导航栏的下面
    label.y =  64 - label.height;
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //3.通过动画移动label以便让用户看到（transform）
    CGFloat duration = 1.0;//动画持续时间
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        //移除label
        [label removeFromSuperview];
    }];
    
}
/**
 *  集成上拉刷新加载更多微博数据
 */
- (void)setupUpRefresh
{
    //添加上拉刷新控件
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses)];
}
/**
 * 加载更多微博数据
 */
- (void)loadMoreStatuses
{
//    ZJLog(@"loadMoreStatuses");
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //    params[@"count"] = @5;//默认是20
    
    //取出最后面的微博
    ZJStatusFrame *lastStatusFrame = [self.statusFrames lastObject];
    //max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    if (lastStatusFrame) {
        long long maxID = lastStatusFrame.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxID);//包装成对象
    }
    
    //通过block（局部函数）的方式，处理微博数据（微博字典数组）
    void(^dealingResult)(NSArray *) = ^(NSArray *statuses){
        
        //取得微博字典数组，并字典转模型(微博字典数组->微博模型数组)
        NSArray *newStatuses = [ZJStatus objectArrayWithKeyValuesArray:statuses];
        
        //将ZJStatus转换为ZJStatusFrame
        NSArray *frames = [self statusFramesWithStatuses:newStatuses];
        
        //将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:frames];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束上拉刷新
        [self.tableView.footer endRefreshing];
    };
    
    //2.根据请求参数从沙盒中加载FMDB缓存好的微博数据（微博字典数组）
    NSArray *statuses = [ZJStatusTool statusesWithParams:params];
    if (statuses.count) {//数据库有数据
        
        dealingResult(statuses);

    }else{
        //3.发送请求
        [ZJHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            //        ZJLog(@"请求成功---%@",json[@"statuses"]);
            
            //FMDB缓存从新浪服务器获取的微博数据（微博字典数组）
            [ZJStatusTool saveStatuses:json[@"statuses"]];
            
            dealingResult(json[@"statuses"]);
            
        } failure:^(NSError *error) {
            ZJLog(@"请求失败---%@",error);
            
            //结束上拉刷新
            [self.tableView.footer endRefreshing];
        }];
    }

}
/**
 * 显示微博未读数
 */
- (void)setupUnreadCount
{
//    ZJLog(@"setupUnreadCount");
    /*
     https://rm.api.weibo.com/2/remind/unread_count.json
     
     请求参数
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	true	int64	需要获取消息未读数的用户UID，必须是当前登录用户
     */
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取得模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //2.发送请求
    [ZJHttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
//        ZJLog(@"请求成功--%@",json[@"status"]);

        //Attempting to badge the application icon but haven't received permission from the user to badge the application
#warning 在iOS8之后，设置应用的application badge value需要得到用户的许可
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        NSString *status = [json[@"status"] description];
        if ([status isEqualToString:@"0"]) {//如果是0则清空
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{//有微博未读数
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.integerValue;

        }
        
        
    } failure:^(NSError *error) {
//        ZJLog(@"请求失败--%@",error);

    }];
}
#pragma mark - 提取的方法
/**
 * 将ZJStatus转化为ZJStatusFrame
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    //遍历status数组
    NSMutableArray *frames = [NSMutableArray array];
    for (ZJStatus *status in statuses) {
        ZJStatusFrame *frame = [[ZJStatusFrame alloc] init];
        frame.status = status;
        [frames addObject:frame];
    }
    return frames;
}


#pragma mark - 点击事件
- (void)popClick
{
    ZJLog(@"popClick");
}
/**
 *  发微博
 */
- (void)compose
{
//    ZJLog(@"compose");
    ZJComposeViewController *compose = [[ZJComposeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)titleBtnClick
{
    ZJLog(@"titleBtnClick");
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    ZJStatusCell *cell = [ZJStatusCell cellWithTableView:tableView];
    
    //2.给cell传微博frame模型（在cell里面设置frame和数据）
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
    
}

/**
 *  计算cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLog(@"didSelectRowAtIndexPath---%d",indexPath.row);
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor grayColor];
    vc.title = @"新控制器";
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
