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

@interface ZJHomeViewController ()

@end

@implementation ZJHomeViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setupNav];
    
    //获得用户信息
    [self setupUserInfo];
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

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"测试数据--主页";
    
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
