//
//  ZJStatusFavoritesViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusFavoritesViewController.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJStatus.h"
#import "ZJStatusFrame.h"
#import <MJExtension.h>
#import "ZJStatusCell.h"
#import "ZJProfileStatusTool.h"
#import "ZJFavorites.h"
#import <MJExtension.h>

@interface ZJStatusFavoritesViewController ()

/** 微博数组--存放的是微博Frame模型 */
@property(nonatomic,strong) NSMutableArray *statusFrames;

@end

@implementation ZJStatusFavoritesViewController
#pragma mark - lazy method
- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏";
    
    //获取当前用户的收藏微博
    [self setupFavoritesStatus];
    
}

#pragma mark - init method
/**
 *  获取当前用户的收藏微博
 */
- (void)setupFavoritesStatus
{
    /*
     https://api.weibo.com/2/favorites.json get
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     */
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
//    params[@"count"] = @1;
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/favorites.json" params:params success:^(id json) {
//        ZJLog(@"请求成功--%@",json[@"favorites"]);//数组
 
        //字典转模型
        NSArray *newFavoriteses = [ZJFavorites objectArrayWithKeyValuesArray:json[@"favorites"]];
    
        //将ZJFavorites转化为ZJStatusFrame
        NSArray *frames = [self statusFramesWithFavoriteses:newFavoriteses];
        
        //将微博数据，添加到总数组的最前面(插入)
        NSRange range = NSMakeRange(0, newFavoriteses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:frames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        ZJLog(@"请求失败--%@",error);
        
    }];

}

/**
 * 将ZJFavorites转化为ZJStatusFrame
 */
- (NSArray *)statusFramesWithFavoriteses:(NSArray *)favoriteses
{
    //遍历status数组
    NSMutableArray *frames = [NSMutableArray array];
    for (ZJFavorites *favorites in favoriteses) {
        ZJStatusFrame *frame = [[ZJStatusFrame alloc] init];
        frame.status = favorites.status;
        [frames addObject:frame];
    }
    return frames;
}

#pragma mark - UITableViewDataSource
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
    
}

@end
