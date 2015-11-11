//
//  ZJCommonViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJCommonViewController.h"
#import "ZJCommonItem.h"
#import "ZJCommonGroup.h"
#import "ZJCommonCell.h"

@interface ZJCommonViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *groups;

@end

@implementation ZJCommonViewController
#pragma mark - 屏蔽tableView的style
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];//分组样式
}

#pragma mark - lazy method
- (NSMutableArray *)groups
{
    if (!_groups) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}

#pragma mark - system method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置tableView的属性
    self.tableView.backgroundColor = ZJGrobalColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//取出cell间的分割线
    self.tableView.sectionFooterHeight = ZJCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(ZJCellMargin - 35, 0, 0, 0);//contentInset表示切掉
   
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZJCommonGroup *group = self.groups[section];
    return group.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ZJCommonCell *cell = [ZJCommonCell cellWithTableView:tableView];
    ZJCommonGroup *group = self.groups[indexPath.section];
    ZJCommonItem *item = group.items[indexPath.row];
    //传ZJCommonItem模型数据和cell的位置相关信息给ZJCommonCell
    cell.item = item;
    [cell setIndexPath:indexPath rowsInSection:group.items.count];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取出item模型
    ZJCommonGroup *group = self.groups[indexPath.section];
    ZJCommonItem *item = group.items[indexPath.row];
    
    //2.判断该item有无需要跳转的目标控制器
    if (item.destVcClass) {
        //        UIViewController *destVc = (UIViewController *)item.destVcClass;//错误
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    //3.判断该item有无需要执行的操作
    if (item.operation) {
        item.operation();
    }
    
}


@end
