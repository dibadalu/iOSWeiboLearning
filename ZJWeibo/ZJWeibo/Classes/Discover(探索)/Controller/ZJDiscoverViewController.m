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
#import "ZJCommonArrowItem.h"
#import "ZJCommonSwitchItem.h"
#import "ZJCommonLabelItem.h"
#import "ZJPublicStatusesViewController.h"
#import "ZJUserSearchViewController.h"


@interface ZJDiscoverViewController ()<UIScrollViewDelegate>

@property(nonatomic,weak) ZJSearchBar *searchBar;

@end

@implementation ZJDiscoverViewController
#pragma mark - system method
- (void)viewDidLoad
{
    
    [super viewDidLoad];

    //设置搜索框
    [self setupSearchBar];
    
    //初始化模型数据
    [self setupGroups];
    
}


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
    hotStatus.destVcClass = [ZJPublicStatusesViewController class];
    hotStatus.subTitle = @"神马";
    ZJCommonItem *findPeople = [ZJCommonItem itemWithTitle:@"找人" icon:@"find_people"];
    findPeople.destVcClass = [ZJUserSearchViewController class];
    findPeople.subTitle = @"乔布斯";
    group.items = @[hotStatus,findPeople];
}
- (void)setupGroup1
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonItem *near = [ZJCommonItem itemWithTitle:@"周边" icon:@"near"];
    near.operation = ^{
        ZJLog(@"点击了周边");
    };
    ZJCommonItem *app = [ZJCommonItem itemWithTitle:@"应用" icon:@"app"];
    
    group.items = @[near,app];
}
- (void)setupGroup2
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonItem *video = [ZJCommonItem itemWithTitle:@"视频" icon:@"video"];
    ZJCommonItem *music = [ZJCommonItem itemWithTitle:@"音乐" icon:@"music"];
    ZJCommonLabelItem *movie = [ZJCommonLabelItem itemWithTitle:@"电影" icon:@"movie"];
    movie.text = @"最新最热门的电影";
    ZJCommonItem *cast = [ZJCommonItem itemWithTitle:@"播客" icon:@"cast"];
    ZJCommonArrowItem *more = [ZJCommonArrowItem itemWithTitle:@"更多" icon:@"more"];

    group.items = @[video,music,movie,cast,more];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}
@end
