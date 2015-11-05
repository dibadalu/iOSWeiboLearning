//
//  ZJDiscoverViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJDiscoverViewController.h"
#import "ZJSearchBar.h"
#import "ZJCommonItem.h"
#import "ZJCommonGroup.h"
#import "ZJCommonCell.h"
#import "ZJCommonArrowItem.h"
#import "ZJCommonSwitchItem.h"
#import "ZJCommonLabelItem.h"

@interface ZJDiscoverViewController ()<UIScrollViewDelegate>

@property(nonatomic,weak) ZJSearchBar *searchBar;
@property(nonatomic,strong) NSMutableArray *groups;


@end

@implementation ZJDiscoverViewController
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

    //设置搜索框
    [self setupSearchBar];
    
    //设置tableView的属性
    self.tableView.backgroundColor = ZJGrobalColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//取出cell间的分割线
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = ZJCellMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(ZJCellMargin - 35, 0, 0, 0);//contentInset表示切掉
    
    //初始化模型数据
    [self setupGroups];
    
//    ZJLog(@"viewDidLoad----%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));

}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
////    ZJLog(@"viewDidAppear----%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
//    
//}

#pragma mark - init method
/**
 *  设置搜索框
 */
- (void)setupSearchBar
{
    ZJSearchBar *searchBar = [[ZJSearchBar alloc] init];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
}
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}
-(void)setupGroup0
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonItem *hotStatus = [ZJCommonItem itemWithTitle:@"热门微博" icon:@"hot_status"];
    hotStatus.subTitle = @"神马";
    ZJCommonItem *findPeople = [ZJCommonItem itemWithTitle:@"找人" icon:@"find_people"];
    findPeople.subTitle = @"乔布斯";
    group.items = @[hotStatus,findPeople];
}
- (void)setupGroup1
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonItem *gameCenter = [ZJCommonItem itemWithTitle:@"游戏中心" icon:@"game_center"];
    ZJCommonItem *near = [ZJCommonItem itemWithTitle:@"周边" icon:@"near"];
    ZJCommonItem *app = [ZJCommonItem itemWithTitle:@"应用" icon:@"app"];
    
    group.items = @[gameCenter,near,app];
}
- (void)setupGroup2
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonItem *video = [ZJCommonItem itemWithTitle:@"视频" icon:@"video"];
    ZJCommonItem *music = [ZJCommonItem itemWithTitle:@"音乐" icon:@"music"];
    music.badgeValue = @"998";//右边样式为数字标识
    ZJCommonLabelItem *movie = [ZJCommonLabelItem itemWithTitle:@"电影" icon:@"movie"];
    movie.text = @"最新最热门的电影";
    ZJCommonSwitchItem *cast = [ZJCommonSwitchItem itemWithTitle:@"播客" icon:@"cast"];
    ZJCommonArrowItem *more = [ZJCommonArrowItem itemWithTitle:@"更多" icon:@"more"];
    
    group.items = @[video,music,movie,cast,more];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}
@end
