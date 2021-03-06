//
//  ZJMessageViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJMessageViewController.h"
#import "ZJCommonItem.h"
#import "ZJCommonGroup.h"
#import "ZJCommonArrowItem.h"
#import "ZJChatViewController.h"



@interface ZJMessageViewController ()

@end

@implementation ZJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //初始化模型数据
    [self setupGroups];

    
}

#pragma mark - 
- (void)setupGroups
{
    [self setupGroup1];
    [self setupGroup2];

}

- (void)setupGroup1
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonArrowItem *at = [ZJCommonArrowItem itemWithTitle:@"@我的" icon:@"messagescenter_at"];
    ZJCommonArrowItem *comments = [ZJCommonArrowItem itemWithTitle:@"评论" icon:@"messagescenter_comments"];
    ZJCommonArrowItem *good = [ZJCommonArrowItem itemWithTitle:@"赞" icon:@"messagescenter_good"];
    ZJCommonArrowItem *messagebox = [ZJCommonArrowItem itemWithTitle:@"订阅消息" icon:@"messagescenter_messagebox"];
    
    group.items = @[at,comments,good,messagebox];
    

}

- (void)setupGroup2
{
    //1.创建组
    ZJCommonGroup *group = [ZJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的所有行
    ZJCommonItem *contact = [ZJCommonItem itemWithTitle:@"微博客服" icon:@"messagescenter_chat"];
    contact.destVcClass = [ZJChatViewController class];
    
    group.items = @[contact];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

@end
