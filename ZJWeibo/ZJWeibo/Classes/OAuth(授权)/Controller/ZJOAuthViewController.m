//
//  ZJOAuthViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJOAuthViewController.h"

@interface ZJOAuthViewController ()<UIWebViewDelegate>
@end

@implementation ZJOAuthViewController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建一个webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = [UIScreen mainScreen].bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //2.用webView加载登陆界面
    /*
     请求地址：  https://api.weibo.com/oauth2/authorize
     请求参数：
     client_id		申请应用时分配的AppKey。
     redirect_uri   授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2053650830&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

#pragma mark - UIWebViewDelegate代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
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
        int fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];

        //利用code的请求标识换取一个accessToken
        [self accessTokenWithCode:code];
        
        //禁止返回回调地址
        return NO;
        
    }
    
    return YES;//返回回调地址
}

/**
 *  利用code的请求标识换取一个accessToken
 */
- (void)accessTokenWithCode:(NSString *)code
{
    
}

@end
