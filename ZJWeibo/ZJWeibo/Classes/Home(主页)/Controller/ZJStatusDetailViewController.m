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
#import "ZJStatusDetailBottomToolBar.h"
#import "ZJStatusDetailTopToolBar.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJStatus.h"
#import "ZJCommentResult.h"
#import "ZJComment.h"
#import <MJExtension.h>
#import "ZJRepostResult.h"

@interface ZJStatusDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ZJStatusDetailTopToolBarDelegate>

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) ZJStatusDetailTopToolBar *topToolBar;
@property(nonatomic,strong) NSMutableArray *comments;
@property(nonatomic,strong) NSMutableArray *reposts;

@end

@implementation ZJStatusDetailViewController
#pragma mark - lazy method
- (ZJStatusDetailTopToolBar *)topToolBar
{
    if (!_topToolBar) {
        self.topToolBar = [ZJStatusDetailTopToolBar toolBar];
        self.topToolBar.delegate = self;//设置代理
        self.topToolBar.status = self.status;//传模型数据给topToolBar
    }
    return _topToolBar;
}

- (NSMutableArray *)comments
{
    if (!_comments) {
        self.comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSMutableArray *)reposts
{
    if (!_reposts) {
        self.reposts = [NSMutableArray array];
    }
    return _reposts;
}

#pragma mark - init method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"微博正文";
    
    //创建tableView
    [self setupTableView];
    //创建微博详情控件
    [self setupDetailView];
    //创建底部工具条
    [self setupBottomToolBar];
    
    //通过UITableViewDelegate创建顶部工具条
    
    
}

#pragma mark - init method
/**
 *  创建tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.width = self.view.width;
    tableView.height = self.view.height - 35;
    tableView.backgroundColor = ZJGrobalColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;

}
/**
 *  创建微博详情控件
 */
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
/**
 *  创建底部工具条
 */
- (void)setupBottomToolBar
{
    ZJStatusDetailBottomToolBar *bottomToolBar = [[ZJStatusDetailBottomToolBar alloc] init];
    bottomToolBar.width = self.view.width;
    bottomToolBar.height = self.view.height - self.tableView.height;
    bottomToolBar.y = CGRectGetMaxY(self.tableView.frame);
    [self.view addSubview:bottomToolBar];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.topToolBar.selectedButtonType == ZJStatusDetailTopToolbarButtonRetweetedType) {
//        return self.reposts.count;
//    }else{
        return self.comments.count;
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
//    if (self.topToolBar.selectedButtonType == ZJStatusDetailTopToolbarButtonRetweetedType) {
//        ZJStatus *status = self.reposts[indexPath.row];//取出微博模型
//        cell.textLabel.text = status.text;
//    }else{
        ZJComment *comment = self.comments[indexPath.row];//取出评论模型
        cell.textLabel.text = comment.text;
//    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.topToolBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.topToolBar.height;
}


#pragma mark - ZJStatusDetailTopToolBarDelegate
- (void)statusDetailTopToolBar:(ZJStatusDetailTopToolBar *)topToolBar didSelectedButton:(ZJStatusDetailTopToolbarButtonType)buttonType
{
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.tableView reloadData];
//    });
    
    switch (buttonType) {
        case ZJStatusDetailTopToolbarButtonRetweetedType:
//            ZJLog(@"转发");
            //获取转发内容
            [self loadRetweeteds];
            break;
        case ZJStatusDetailTopToolbarButtonCommentType:
//            ZJLog(@"评论");
            //获取评论内容
            [self loadComments];
            break;
    }
    
}

#pragma mark - other method
/**
 *  获取转发内容
 */
- (void)loadRetweeteds
{
//    ZJLog(@"loadRetweeteds");
    /*
     https://api.weibo.com/2/statuses/repost_timeline.json  get
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     id	true	int64	需要查询的微博ID。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过200，默认为20。
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取出账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"id"] = self.status.idstr;
    params[@"count"] = @20;
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/statuses/repost_timeline.json" params:params success:^(id json) {
        ZJLog(@"请求成功---%@--%@",json[@"total_number"],json);//转发内容的接口被封
       
        //将字典 转换为 转发结果模型
        ZJRepostResult *repostResults = [ZJRepostResult objectWithKeyValues:json];
        //更新转发总数
        self.status.reposts_count = repostResults.total_number;
        self.topToolBar.status = self.status;
        //将转发结果模型中的转发数组添加到转发总数组中
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, repostResults.reposts.count)];
        [self.reposts insertObjects:repostResults.reposts atIndexes:set];
        
        //刷新表格
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//        });
        

 
    } failure:^(NSError *error) {
        ZJLog(@"请求失败---%@",error);
        
    }];

}
/**
 *  获取评论内容
 */
- (void)loadComments
{
//    ZJLog(@"loadComments");
    /*
     https://api.weibo.com/2/comments/show.json  get 
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     id	true	int64	需要查询的微博ID。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
     count	false	int	单页返回的记录条数，默认为50。
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取出账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"id"] = self.status.idstr;
    params[@"count"] = @20;
    ZJComment *firstComment = [self.comments firstObject];
    if (firstComment) {
        params[@"since_id"] = firstComment.idstr;
    }
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/comments/show.json" params:params success:^(id json) {
//        ZJLog(@"请求成功---%@--%@",json[@"total_number"],json);//评论总数
        //将字典 转换为 评论结果模型
        ZJCommentResult *commentResults = [ZJCommentResult objectWithKeyValues:json];
        //更新评论总数
        self.status.comments_count = commentResults.total_number;
        self.topToolBar.status = self.status;
        //将评论结果模型中的评论数组添加到评论总数组中
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, commentResults.comments.count)];
        [self.comments insertObjects:commentResults.comments atIndexes:set];
        
        //刷新表格
//        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
//        });
   
    } failure:^(NSError *error) {
        ZJLog(@"请求失败---%@",error);

    }];
}

@end
