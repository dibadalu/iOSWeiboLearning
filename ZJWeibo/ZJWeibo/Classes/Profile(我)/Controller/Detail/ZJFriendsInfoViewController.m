//
//  ZJFriendsInfoViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/11.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJFriendsInfoViewController.h"
#import "ZJAccount.h"
#import "ZJAccountTool.h"
#import "ZJHttpTool.h"
#import "ZJUser.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>


@interface ZJFriendsInfoViewController ()

/** 关注总数组，存放的是每一个用户模型 */
@property(nonatomic,strong) NSMutableArray *users;

@end

@implementation ZJFriendsInfoViewController
#pragma mark - lazy method
- (NSMutableArray *)users
{
    if (!_users) {
        self.users = [NSMutableArray array];
    }
    return _users;
}

#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部关注";
    
    //获取关注列表
    [self setupFriendsList];
}

- (void)setupFriendsList
{
    /*
     https://api.weibo.com/2/friendships/friends.json  get
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户UID。
     
     */
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/friendships/friends.json" params:params success:^(id json) {
//        ZJLog(@"请求成功--%@",json[@"users"]);
        
        //关注的用户字典数组 （字典数组转模型数组）
        NSArray *usersArray = [ZJUser objectArrayWithKeyValuesArray:json[@"users"]];
        
        //将最新的关注数据，添加到总数组的最前面（插入）
        NSRange range = NSMakeRange(0, usersArray.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.users insertObjects:usersArray atIndexes:set];
   
        //刷新表格
        [self.tableView reloadData];
        

    } failure:^(NSError *error) {
        ZJLog(@"请求失败--%@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"friend";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    ZJUser *user = self.users[indexPath.row];//取出用户模型
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.descriptionText;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    return cell;
}




@end
