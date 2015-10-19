//
//  ZJHomeViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJHomeViewController.h"

@interface ZJHomeViewController ()

@end

@implementation ZJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] forState:UIControlStateHighlighted];
    
    [leftBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

#pragma mark - 点击事件
- (void)popClick
{
    NSLog(@"popClick");
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
