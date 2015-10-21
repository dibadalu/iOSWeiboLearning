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

@interface ZJHomeViewController ()

/** 微博模型数组（一个模型代表一条微博） 可变数组*/
@property(nonatomic,strong) NSMutableArray *statuses;

@end

@implementation ZJHomeViewController
/**
 *  微博模型数组的懒加载
 */
- (NSMutableArray *)statuses
{
    if (!_statuses) {
        self.statuses = [NSMutableArray array];
    }
    return _statuses;
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
    ZJStatus *firstStatus = [self.statuses firstObject];
    if (firstStatus) {
        //若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        params[@"since_id"] = firstStatus.idstr;
    }
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
//        ZJLog(@"请求成功---%@",json[@"statuses"]);
        //取得微博字典数组，字典转模型(微博字典数组->微博模型数组)
        NSArray *newStatuses = [ZJStatus objectArrayWithKeyValuesArray:json[@"statuses"]];

        //将最新的微博数据，添加到总数组的最前面(插入)
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuses insertObjects:newStatuses atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [self.tableView.header endRefreshing];
        
        //显示最新微博的数量
        [self showNewStatusesCount:newStatuses.count];
        
    } failure:^(NSError *error) {
        ZJLog(@"请求失败---%@",error);
        
        //结束下拉刷新
        [self.tableView.header endRefreshing];
    }];
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
//    [self.navigationController.view addSubview:label];
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
    ZJStatus *lastStatus = [self.statuses lastObject];
    //max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    if (lastStatus) {
        long long maxID = lastStatus.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxID);//包装成对象
    }
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
        //        ZJLog(@"请求成功---%@",json[@"statuses"]);
        //取得微博字典数组，并字典转模型(微博字典数组->微博模型数组)
        NSArray *newStatuses = [ZJStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        //将更多的微博数据，添加到总数组的最后面
        [self.statuses addObjectsFromArray:newStatuses];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束上拉刷新
        [self.tableView.footer endRefreshing];
        
 
    } failure:^(NSError *error) {
        ZJLog(@"请求失败---%@",error);
        
        //结束上拉刷新
        [self.tableView.footer endRefreshing];
    }];

}


#pragma mark - 点击事件
- (void)popClick
{
    ZJLog(@"popClick");
}

- (void)compose
{
    ZJLog(@"compose");
}

- (void)titleBtnClick
{
    ZJLog(@"titleBtnClick");
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"status";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //取出微博字典数组
//    NSDictionary *status = self.statuses[indexPath.row];
    ZJStatus *status = self.statuses[indexPath.row];
    //设置微博的用户名
//    NSDictionary *user = status[@"user"];
//    cell.textLabel.text = user[@"name"];
    ZJUser *user = status.user;
    cell.textLabel.text = user.name;
    
    //设置微博的正文
//    cell.detailTextLabel.text = status[@"text"];
    cell.detailTextLabel.text = status.text;
    
    //设置头像
    UIImage *placeImage = [UIImage imageNamed:@"avatar_default_small"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:placeImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor grayColor];
    vc.title = @"新控制器";
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
