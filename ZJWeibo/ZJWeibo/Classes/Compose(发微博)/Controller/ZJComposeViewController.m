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
#import "ZJComposePhotosView.h"
#import <AFNetworking.h>
#import "ZJEmotionKeyboard.h"
#import "ZJEmotion.h"
#import "ZJEmotionTextView.h"


@interface ZJComposeViewController ()<UITextViewDelegate,ZJComposeToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** 输入控件 */
@property(nonatomic,strong) ZJEmotionTextView *textView;
/** 工具条 */
@property(nonatomic,strong) ZJComposeToolBar *toolBar;
/** 相册（存放拍照或者相册中选择的图片） */
@property(nonatomic,weak) ZJComposePhotosView *photosView;
/** 记录是否正在切换键盘(主要作用控制切换键盘时微博工具条不要移动) */
@property(nonatomic,assign) BOOL switchingKeyBoard;
/** 键盘 strong 整个生存期都只有一个键盘 */
@property(nonatomic,strong) ZJEmotionKeyboard *emotionKeyboard;

@end

@implementation ZJComposeViewController
#pragma mark - 懒加载
- (ZJEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        ZJEmotionKeyboard *emotionKeyboard = [[ZJEmotionKeyboard alloc] init];
        emotionKeyboard.width = self.view.width;
        emotionKeyboard.height = 216;
        self.emotionKeyboard = emotionKeyboard;
    }
    return _emotionKeyboard;
}

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
    
    //添加textView的相册
    [self setupPhotosView];
    
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
    ZJEmotionTextView *textView = [[ZJEmotionTextView alloc] init];
//    textView.backgroundColor = [UIColor redColor];
    //垂直方向上永远可用拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    textView.placedholder = @"分享新鲜事......";
    textView.placedholderColor = [UIColor grayColor];
    textView.delegate = self;//设置代理
    [self.view addSubview:textView];
    self.textView = textView;
    
    
    //通知
    //文字改变的通知
    [ZJNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    //键盘frame发生改变的通知
    [ZJNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //表情键盘上表情按钮被点击的通知
    [ZJNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:ZJEmotionDidSelectNotification object:nil];
    //表情键盘上删除按钮被点击的通知
    [ZJNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:ZJEmotionDidDeleteNotification object:nil];
    
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
    toolBar.delegate = self;//设置代理
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
}
/**
 *  添加textView上的相册
 */
- (void)setupPhotosView
{
    ZJComposePhotosView *photosView = [[ZJComposePhotosView alloc] init];
    photosView.width = self.view.width;
    photosView.height = 300;
    photosView.y = 100;
//    photosView.backgroundColor = ZJRandomColor;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
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
    if (self.photosView.photos.count) {//有配图
        [self sendWithImage];
    }else{//没配图
        [self sendWithoutImage];
    }
    
    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendWithoutImage
{
    /*
     https://api.weibo.com/2/statuses/update.json  post
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字
     */
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取出账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.textView.fullText;
    
    //2.发送请求
    [ZJHttpTool post:@"https://api.weibo.com/2/statuses/update.json" params:params success:^(id json) {
        //        ZJLog(@"请求成功--%@",json[@"text"]);
        [MBProgressHUD showSuccess:@"您的新鲜事成功分享了!"];
    } failure:^(NSError *error) {
        //        ZJLog(@"请求失败--%@",error);
        [MBProgressHUD showError:@"网络繁忙，麻烦重新发送!"];
        
    }];
  
}
- (void)sendWithImage
{
    /*
     https://api.weibo.com/2/statuses/upload.json  post
     
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字
     pic	true	binary	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。     */
    
    //0.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //1.拼接请求参数
    ZJAccount *account = [ZJAccountTool account];//取出账号模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.textView.fullText;
    
    //2.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage *image = [self.photosView.photos firstObject];
//        ZJLog(@"%@",self.photosView.photos);
        NSData *data = UIImageJPEGRepresentation(image, 1.0);//5M以内的图片
        //上传可能有点慢
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation , id json) {
        [MBProgressHUD showSuccess:@"您的新鲜事成功分享了!"];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，麻烦重新发送!"];

    }];
    
    
}
- (void)textDidChange
{
//    ZJLog(@"textDidChange");
    //当textView有文字，发送微博按钮可用
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //0.如果正在切换键盘，不要移动工具条
    if (self.switchingKeyBoard) {
        return;
    }
    
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
- (void)emotionDidSelect:(NSNotification *)notification
{
//    ZJLog(@"emotionDidSelect");
    ZJEmotion *emotion = notification.userInfo[ZJSelectEmotion];//取出携带的模型数据
//    ZJLog(@"%@---表情按钮被点击了",emotion.chs);
    //插入文字或图片
    [self.textView insertEmotion:emotion];
}
- (void)emotionDidDelete
{
    //在textView删除之前输入的文字或图片
    [self.textView deleteBackward];
}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //结束编辑
    [self.textView endEditing:YES];
}

#pragma mark - ZJComposeToolBarDelegate
- (void)composeToolBar:(ZJComposeToolBar *)toolBar didClickbuttonType:(ZJComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ZJComposeToolbarButtonTypeCamera://相机
            ZJLog(@"相机");
//            [self openCamera];//需要真机调试
            
            break;
        case ZJComposeToolbarButtonTypePicture://相册
//            ZJLog(@"相册");
            [self openAlbum];

            break;
        case ZJComposeToolbarButtonTypeTrend://#
            ZJLog(@"#");

            break;
        case ZJComposeToolbarButtonTypeMention://@
            ZJLog(@"@");

            break;
        case ZJComposeToolbarButtonTypeEmotion://表情
//            ZJLog(@"表情");
            //切换键盘
            [self switchKeyboard];

            break;
    }
}

#pragma mark - 其他方法
/**
 *  拍照
 */
- (void)openCamera
{
    //    ZJLog(@"openCamera");
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    
}
/**
 *  打开图库
 */
- (void)openAlbum
{
    //    ZJLog(@"openAlbum");
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    
}
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
/**
 *  切换键盘
 */
- (void)switchKeyboard
{
//    ZJLog(@"switchKeyboard");
    
    if (self.textView.inputView == nil) {//如果是系统键盘，切换表情键盘
        self.textView.inputView = self.emotionKeyboard;
        
        //显示键盘按钮(借助布尔值)
        self.toolBar.showKeyboardButton = YES;
        
    }else{//如果是表情键盘，切换系统键盘
        self.textView.inputView = nil;
        self.toolBar.showKeyboardButton = NO;
    }
    
    //正在切换键盘
    self.switchingKeyBoard = YES;
    
    //注意：必须先退出原先的键盘
    [self.textView endEditing:YES];
    
    //已经切换完键盘
    self.switchingKeyBoard = NO;
    
    //延迟0.1s切换另外一个键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
        
    });
}
#pragma mark - UIImagePickerControllerDelegate
/**
 *  从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //info中包含了选择的图片
    //    HMLog(@"%@",info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //给textView上的相册添加图片
    [self.photosView addPhoto:image];
    
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
