//
//  ZJUserSearchViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/16.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJUserSearchViewController.h"
#import "ZJSearchBar.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJUserSuggestion.h"
#import <MJExtension.h>


@interface ZJUserSearchViewController ()<UIScrollViewDelegate>

/** 搜索框 */
@property(nonatomic,weak) ZJSearchBar *searchBar;

/** 搜索建议数组 */
@property(nonatomic,strong) NSMutableArray *suggestions;

@end

@implementation ZJUserSearchViewController

- (NSMutableArray *)suggestions
{
    if (!_suggestions) {
        _suggestions = [NSMutableArray array];
    }
    return _suggestions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置搜索框
    [self setupSearchBar];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - init method
/**
 *  设置搜索框
 */
- (void)setupSearchBar{
    
    ZJSearchBar *searchBar = [[ZJSearchBar alloc] init];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    //文字改变的通知
    [ZJNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
}

#pragma mark - action method
- (void)textDidChange
{
    ZJLog(@"textDidChange---%@",self.searchBar.text);
    
    /*
     https://api.weibo.com/2/search/suggestions/users.json get
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     q	true	string	搜索的关键字，必须做URLencoding。
     
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取得账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
#warning  必须做URLencoding
    NSString *newSearchString = [self.searchBar.text urlencode];
    params[@"q"] = newSearchString;
    params[@"count"] = @5;
    
#warning  用户关键字联想搜索 请求失败
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/search/suggestions/users.json" params:params success:^(id json) {
//       ZJLog(@"请求成功-%@",json);
        
        //字典转模型
        NSArray *userSuggestions = [ZJUserSuggestion objectArrayWithKeyValuesArray:json];
        
        //将获取到模型数据添加到总数组suggestions
        NSRange range = NSMakeRange(0, userSuggestions.count);
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.suggestions insertObjects:userSuggestions atIndexes:indexSet];
        
        //刷新表格
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        ZJLog(@"请求失败-%@",error);
    }];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestions.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"suggestion";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    ZJUserSuggestion *userSeggestion = self.suggestions[indexPath.row];//取出模型
    cell.textLabel.text = userSeggestion.screen_name;
    
    return cell;
}

#pragma makr - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLog(@"选中了--%d",indexPath.row);
}


@end
