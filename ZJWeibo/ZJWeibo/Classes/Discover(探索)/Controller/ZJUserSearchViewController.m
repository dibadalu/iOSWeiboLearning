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


@interface ZJUserSearchViewController ()<UIScrollViewDelegate>

@property(nonatomic,weak) ZJSearchBar *searchBar;

@end

@implementation ZJUserSearchViewController

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
    params[@"count"] = @10;
    
#warning  用户关键字联想搜索 请求失败
    //2.发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/search/suggestions/users.json" params:params success:^(id json) {
       ZJLog(@"请求成功-%@",json);
       
        
    } failure:^(NSError *error) {
        ZJLog(@"请求失败-%@",error);
    }];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

@end
