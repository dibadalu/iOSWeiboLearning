//
//  ZJStatusesInfoViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusesInfoViewController.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJStatus.h"
#import "ZJStatusFrame.h"
#import <MJExtension.h>
#import "ZJStatusCell.h"
#import "ZJProfileStatusTool.h"

@interface ZJStatusesInfoViewController ()

/** 微博数组--存放的是微博Frame模型 */
@property(nonatomic,strong) NSMutableArray *statusFrames;

@end

@implementation ZJStatusesInfoViewController
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
    
    
   self.title = @"全部微博";
    
    //获取当前用户的微博
    [self setupUserStatus];
    
}

#pragma mark - init method
/**
 *  获取当前用户的微博
 */
- (void)setupUserStatus
{
    /*
     https://api.weibo.com/2/statuses/user_timeline.json  get
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取得账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //取出最新的微博
    ZJStatusFrame *firstStatusFrame = [self.statusFrames firstObject];
    if (firstStatusFrame) {
        //若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        params[@"since_id"] = firstStatusFrame.status.idstr;
    }
    
    //通过block（局部函数）的方式，处理微博数据（微博字典数组）
    void(^dealingResult)(NSArray *) = ^(NSArray *statuses){
        
        //取得微博字典数组，字典转模型(微博字典数组->微博模型数组)
        NSArray *newStatuses = [ZJStatus objectArrayWithKeyValuesArray:statuses];
        
        //将ZJStatus转化为ZJStatusFrame
        NSArray *frames = [self statusFramesWithStatuses:newStatuses];
        
        //将最新的微博数据，添加到总数组的最前面(插入)
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:frames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
    };
    
    //2.根据请求参数从沙盒中加载FMDB缓存的微博数据
    NSArray *statuses = [ZJProfileStatusTool statusesWithParams:params];
    if (statuses.count) {//数据库有数据
        
        dealingResult(statuses);
        
    }else{
        //3.发送请求
        [ZJHttpTool get:@"https://api.weibo.com/2/statuses/user_timeline.json" params:params success:^(id json) {
            //        ZJLog(@"请求成功-%@",json[@"statuses"]);
            
            //FMDB缓存从新浪获取的微博字典数组
            [ZJProfileStatusTool saveStatuses:json[@"statuses"]];
            
            dealingResult(json[@"statuses"]);
            
        } failure:^(NSError *error) {
            ZJLog(@"请求失败-%@",error);
        }];
    }
    
}
/**
 * 将ZJStatus转化为ZJStatusFrame
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    //遍历status数组
    NSMutableArray *frames = [NSMutableArray array];
    for (ZJStatus *status in statuses) {
        ZJStatusFrame *frame = [[ZJStatusFrame alloc] init];
        frame.status = status;
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
