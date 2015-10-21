//
//  ZJHomeViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJHomeViewController.h"
#import "UIBarButtonItem+ZJExtension.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJUser.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "ZJStatus.h"

@interface ZJHomeViewController ()

/** 微博模型数组（一个模型代表一条微博） */
@property(nonatomic,strong) NSArray *statuses;

@end

@implementation ZJHomeViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setupNav];
    
    //获得用户信息
    [self setupUserInfo];
    
    //加载最新的微博数据
    [self loadNewsStatus];
    
}

#pragma mark - 初始化方法
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
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
//        ZJLog(@"请求成功---%@",json[@"statuses"]);
        //取得微博字典数组
//        self.statuses = json[@"statuses"];
        //字典转模型(微博字典数组->微博模型数组)
        self.statuses = [ZJStatus objectArrayWithKeyValuesArray:json[@"statuses"]];

        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        ZJLog(@"请求失败---%@",error);
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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
