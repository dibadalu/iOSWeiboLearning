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

@interface ZJStatusDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ZJStatusDetailTopToolBarDelegate>

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) ZJStatusDetailTopToolBar *topToolBar;

@end

@implementation ZJStatusDetailViewController
#pragma mark - lazy method
- (ZJStatusDetailTopToolBar *)topToolBar
{
    if (!_topToolBar) {
        self.topToolBar = [ZJStatusDetailTopToolBar toolBar];
        self.topToolBar.delegate = self;//设置代理
    }
    return _topToolBar;
}

#pragma mark - init method
- (void)viewDidLoad {
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
    tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    
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
    switch (buttonType) {
        case ZJStatusDetailTopToolbarButtonRetweetedType:
            ZJLog(@"转发");
            break;
        case ZJStatusDetailTopToolbarButtonCommentType:
            ZJLog(@"评论");
            break;
    }
}

@end
