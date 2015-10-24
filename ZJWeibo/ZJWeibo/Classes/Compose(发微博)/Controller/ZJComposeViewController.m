//
//  ZJComposeViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJComposeViewController.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJTextView.h"
#import "ZJHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZJComposeToolBar.h"

@interface ZJComposeViewController ()

/** 输入控件 */
@property(nonatomic,strong) ZJTextView *textView;
/** 工具条 */
@property(nonatomic,strong) ZJComposeToolBar *toolBar;

@end

@implementation ZJComposeViewController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏的内容
    [self setupNav];
    
    //添加输入控件
    [self setupTextView];
    
    //设置键盘工具条
    [self setupToolBar];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

/**
 *  移除观察者
 */
- (void)dealloc
{
    [ZJNotificationCenter removeObserver:self];
}

#pragma mark - 初始化方法
/**
 *  设置导航栏的内容
 */
- (void)setupNav
{
    //设置导航栏按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //设置导航栏的标题文字
    //取出账号模型里存放的用户昵称
    NSString *name = [ZJAccountTool account].name;
    self.navigationItem.title = name;
}
/**
 *  添加输入控件
 */
- (void)setupTextView
{
    //在导航控制器中，textView会自动设置contenInset，默认是{64, 0, 0, 0}，光标下移
    ZJTextView *textView = [[ZJTextView alloc] init];
//    textView.backgroundColor = [UIColor redColor];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    textView.placedholder = @"分享新鲜事......";
    textView.placedholderColor = [UIColor grayColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    
    //通知
    //文字改变发出通知
    [ZJNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    //键盘frame发生改变发出通知
    [ZJNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
/**
 *  设置键盘工具条
 */
- (void)setupToolBar
{
    ZJComposeToolBar *toolBar = [[ZJComposeToolBar alloc] init];
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.y = self.view.height - toolBar.height;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
}



#pragma mark - 点击事件
- (void)cancel
{
//    ZJLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)send
{
//    ZJLog(@"send");
    /*
     https://api.weibo.com/2/statuses/update.json  post 
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取出账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.textView.text;
    
    //2.发送请求
    [ZJHttpTool post:@"https://api.weibo.com/2/statuses/update.json" params:params success:^(id json) {
//        ZJLog(@"请求成功--%@",json[@"text"]);
        [MBProgressHUD showSuccess:@"您的新鲜事成功分享了!"];
    } failure:^(NSError *error) {
//        ZJLog(@"请求失败--%@",error);
        [MBProgressHUD showError:@"网络繁忙，麻烦重新发送!"];

    }];
    
    //3.dismiss
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (void)textDidChange
{
//    ZJLog(@"textDidChange");
    //当textView有文字，发送微博按钮可用
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //    ZJLog(@"keyboardDidChangeFrame--%@",notification);
    /*
     userInfo = {
     //键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     //键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     //键盘弹出\隐藏动画执行的节奏（先快后慢、匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    //通过动画移动toolBar
    //取出notification的userInfo
    NSDictionary *userInfo = notification.userInfo;
    //键盘弹出后的frame
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘弹出动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.y = frame.origin.y - self.toolBar.height;
    }];
    
}

@end

/**
 UITextField：
 1.文字永远是一行，不能显示多行文字
 2.有placeHolder属性设置占位文字
 3.继承自UIControl
 4.监听行为：
 1>设置代理
 2>addTarget:action:forControlEvents:
 3>通知:UITextFieldTextDidChangeNotification
 
 
 UITextView：
 1.可以显示任意行文字
 2.不能设置占位文字
 3.继承自UIScollView
 4.监听行为：
 1>设置代理
 2>通知：UITextViewTextDidChangeNotification
 
 */
