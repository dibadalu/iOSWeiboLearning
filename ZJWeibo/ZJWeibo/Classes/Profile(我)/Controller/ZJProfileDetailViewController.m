//
//  ZJProfileDetailViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileDetailViewController.h"

@interface ZJProfileDetailViewController ()

@property(nonatomic,weak) UITableView *tableView;

@end

@implementation ZJProfileDetailViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置tableView
    [self setupTableView];
}

#pragma mark - init method
/**
 *  设置tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.frame ;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


@end
