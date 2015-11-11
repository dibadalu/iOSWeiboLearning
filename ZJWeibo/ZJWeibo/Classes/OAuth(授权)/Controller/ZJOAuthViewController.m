//
//  ZJOAuthViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJOAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ZJHttpTool.h"
#import "ZJAccount.h"
#import "ZJAccountTool.h"
#import "ZJTabBarViewController.h"

@interface ZJOAuthViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation ZJOAuthViewController

#pragma mark - system method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建一个webView
    _webView = [[UIWebView alloc] init];
    _webView.frame = [UIScreen mainScreen].bounds;
    _webView.delegate = self;
    self.view = _webView;
    
    //2.用webView加载登陆界面
    /*
     请求地址：  https://api.weibo.com/oauth2/authorize
     请求参数：
     client_id		申请应用时分配的AppKey。
     redirect_uri   授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",ZJAppKey,ZJRedirctURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
    [MBProgressHUD showMessage:@"正在加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError");
    [MBProgressHUD hideHUD];

}

/**
 *  拦截所有url请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"shouldStartLoadWithRequest--%@",request.URL.absoluteString);
//   事例 shouldStartLoadWithRequest--http://www.baidu.com/?code=ddd94d85daed9792639c057a081d2128
    
    //1.获得url
    NSString *url = request.URL.absoluteString;
    
    //2.判断是否是回调地址（是否有code）
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {//是回调地址
        //截取code=后面的参数值(request token,请求标识)
        NSUInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];

        //利用code的请求标识换取一个accessToken
        [self accessTokenWithCode:code];
        
        //禁止返回回调地址
        return NO;
        
    }
    
    return YES;//返回回调地址
}

#pragma mark - custom method
/**
 *  利用code的请求标识换取一个accessToken
 */
- (void)accessTokenWithCode:(NSString *)code
{
    /*
     url：https://api.weibo.com/oauth2/access_token

     请求参数：
     client_id		申请应用时分配的AppKey。
     client_secret  申请应用时分配的AppSecret。
     grant_type		请求的类型，填写authorization_code
     code	     	调用authorize获得的code值。
     redirect_uri	回调地址，需需与注册应用里的回调地址一致。
     */
    
    //1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = ZJAppKey;
    params[@"client_secret"] = ZJAppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = ZJRedirctURI;
    params[@"code"] = code;
    
    //2.发送请求
    //id json 是请求成功后，从服务器获取的信息通过该方法回调到这里
    [ZJHttpTool post:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id json) {
        
//        ZJLog(@"请求成功---%@",json);
        /*
         请求成功---{
         "access_token" = "2.00vZcHuBU5uyOCf668bef713teS3EB";
         "expires_in" = 157679999;
         "remind_in" = 157679999;
         uid = 1745424243;
         }
         */
        [MBProgressHUD hideHUD];
        //将返回的账号字典数据 -> 账号模型，存进沙盒
        ZJAccount *account = [ZJAccount accountWithDict:json];
        //存储账号信息
        [ZJAccountTool saveAccount:account];
        //切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[ZJTabBarViewController alloc] init];
        
    } failure:^(NSError *error) {
        
        ZJLog(@"请求失败---%@",error);
        [MBProgressHUD hideHUD];
        
    }];
    
}



@end
