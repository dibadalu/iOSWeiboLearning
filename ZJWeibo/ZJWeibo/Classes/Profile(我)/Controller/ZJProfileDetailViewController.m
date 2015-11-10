//
//  ZJProfileDetailViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileDetailViewController.h"


#define ZJProfileDetailHeaderH 200
#define ZJProfileDetailHeaderMinH 64
#define ZJProfileDetailTabBarH 44

@interface ZJProfileDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHCons;

@property(nonatomic,weak) UILabel *nameLabel;

@property(nonatomic,assign) CGFloat lastOffsetY;

@end

@implementation ZJProfileDetailViewController

#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView的属性
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.lastOffsetY = - (ZJProfileDetailHeaderH + ZJProfileDetailTabBarH);
    
    self.tableView.contentInset = UIEdgeInsetsMake(ZJProfileDetailHeaderH + ZJProfileDetailTabBarH, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;//不需要添加额外的滚动区域
    
    // 设置导航条的透明度为0
    self.navigationController.navigationBar.alpha = 0;
    
    // 设置导航条的标题
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"dibadalu";
    [nameLabel sizeToFit];
    self.navigationItem.titleView = nameLabel;
    self.nameLabel = nameLabel;

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
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"----%d",indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    ZJLog(@"%f",scrollView.contentOffset.y);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    //计算tableView拖动的距离
    CGFloat delta = offsetY - self.lastOffsetY;
    //计算headerView显示的高度(往上拖动，高度减少)
    CGFloat height = ZJProfileDetailHeaderH - delta;
    
    if (height < ZJProfileDetailHeaderMinH) {
        height = ZJProfileDetailHeaderMinH;
    }
    
    self.headerViewHCons.constant = height;
    
    //设置导航条的透明度
    CGFloat alpha = delta / (ZJProfileDetailHeaderH - ZJProfileDetailHeaderMinH);
    //当alpha大于1，导航条半透明，因此做处理，大于1，就直接=0.99
    if (alpha >= 1) {
        alpha = 0.99;
    }
    self.nameLabel.alpha = alpha;
    self.navigationController.navigationBar.alpha = alpha;
}

@end
