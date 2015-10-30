//
//  ZJStatusDetailViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/30.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusDetailViewController.h"
#import "ZJStatusDetailView.h"
#import "ZJStatusDetailFrame.h"

@interface ZJStatusDetailViewController ()

@property(nonatomic,weak) UITableView *tableView;

@end

@implementation ZJStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"微博正文";
    
    //创建tableView
    [self setupTableView];
    //创建微博详情控件
    [self setupDetailView];
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.width = self.view.width;
    tableView.height = self.view.height - 35;
    tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.delegate = self;
//    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;

}

- (void)setupDetailView
{
    ZJStatusDetailView *detailView = [[ZJStatusDetailView alloc] init];
    ZJStatusDetailFrame *detailFrame = [[ZJStatusDetailFrame alloc] init];
    detailFrame.status = self.status;//传微博数据
    detailView.detailFrame = detailFrame;//传frame数据
    //设置微博详情的高度
    detailView.height = detailFrame.frame.size.height;
    self.tableView.tableHeaderView = detailView;
}


@end
