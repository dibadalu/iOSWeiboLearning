//
//  ZJChatViewController.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJChatViewController.h"
#import "ZJInputView.h"
#import "ZJMessageModel.h"
#import "ZJMessageFrameModel.h"
#import "ZJMessageCell.h"

@interface ZJChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property(nonatomic,strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView底部约束
@property(nonatomic,strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束

@property(nonatomic,strong) UITableView *tableView;//表格;

@property(nonatomic,strong) NSMutableArray *messageFrameModels;//消息数组
@property(nonatomic,strong) NSDictionary *autoReplay;//自动回复消息字典

@end

@implementation ZJChatViewController
- (NSMutableArray *)messageFrameModels{
    
    if (!_messageFrameModels) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
        NSArray *msgArray = [NSArray arrayWithContentsOfFile:path];
        
        //遍历msgArray，将字典转换为模型
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in msgArray) {
            //字典转模型
            ZJMessageModel *messageModel = [ZJMessageModel messageWithDict:dict];
            
            //将消息模型转为消息frame模型
            ZJMessageFrameModel *messageFrameModel = [[ZJMessageFrameModel alloc] init];
            messageFrameModel.messageModel = messageModel;
            
            //将模型添加到临时数组中
            [tempArray addObject:messageFrameModel];
        }
        _messageFrameModels = tempArray;

    }
    
    return _messageFrameModels;
}


- (NSDictionary *)autoReplay{
    
    if (!_autoReplay) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"autoReplay.plist" ofType:nil];
        _autoReplay = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _autoReplay;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"聊天";
    
    //初始化界面
    [self setupMsgView];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}


#pragma mark - 初始化界面
- (void)setupMsgView{
    
    
    //代码方式实现自动布局 VFL
    //创建一个tableView
    UITableView *tableView = [[UITableView alloc] init];
    //    tableView.backgroundColor = [UIColor redColor];
    tableView.allowsSelection = NO;//cell不可选中
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉分割线
    tableView.delegate = self;
    tableView.dataSource = self;
#warning 代码实现自动布局，要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建输入框view
    ZJInputView *inputView = [ZJInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    //设置代理
    inputView.textView.delegate = self;
    //监听add按钮
//    [inputView.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputView];
    
    
    //自动布局
    NSDictionary *views = @{@"tableView":tableView,
                            @"inputView":inputView};
    //水平方向的约束
    //1.tableview水平方向的约束
    NSArray *tableViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHContraints];
    
    //2.inputView水平方向的约束
    NSArray *inputViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHContraints];
    
    //垂直方向的约束
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vContraints];
    //    WCLog(@"%@",vContraints);
    //添加inputView高度约束
    self.inputViewHeightConstraint = vContraints[2];
    //添加inputView底部约束
    self.inputViewBottomConstraint = [vContraints lastObject];
    
}

#pragma mark - 键盘的触发事件
/**
 *  即将显示键盘
 */
- (void)keyboardWillShow:(NSNotification *)noti{
    
    //    NSLog(@"%@",noti.userInfo);
    //获取键盘的高度
    CGRect kyEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kyHeight = kyEndFrm.size.height;
    
#warning iOS7以下，当屏幕是横屏时，键盘的高度是size.width
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kyHeight = kyEndFrm.size.width;
    }
    self.inputViewBottomConstraint.constant = kyHeight;
    
    //自动滚动到表格底部
    [self scrollToTableBottom];
    
}
/**
 *  即将隐藏键盘
 */
- (void)keyboardWillHide:(NSNotification *)noti{
    //隐藏键盘的时候，距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageFrameModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    ZJMessageCell *cell = [ZJMessageCell messageCellWithTableView:tableView];
    //取出消息frame模型
    ZJMessageFrameModel *messageFrameModel = self.messageFrameModels[indexPath.row];
    //传递给cell
    cell.messageFrameModel = messageFrameModel;
    
    return cell;
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取出消息frame模型
    ZJMessageFrameModel *messageFrameModel = self.messageFrameModels[indexPath.row];
    return messageFrameModel.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate 文本输入框
- (void)textViewDidChange:(UITextView *)textView{
    
//    ZJLog(@"%@",textView.text);
    //内容显示大小
    CGSize contentSize = textView.contentSize;
//    ZJLog(@"%f",contentSize.height);// 33 50 67
    //取出内容的显示高度
    CGFloat contentH = contentSize.height;
    if (contentH > 33 && contentH < 67 ) {
        //设置inputView的高度约束
        self.inputViewHeightConstraint.constant = contentH + 12;
    }
    
    NSString *contentText = textView.text;
    if ([contentText rangeOfString:@"\n"].length != 0) {//有换行符号
        //发送数据
//        ZJLog(@"发送数据：%@",contentText);
        
        //去除换行符
        contentText = [contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //发送内容
        [self sendMsgWithText:contentText type:ZJMessageModelTypeMe];
        
        //自动回复内容
        NSString *autoReplayText = [self autoReplayWithText:contentText];
        //将自动回复添加成聊天消息
        [self sendMsgWithText:autoReplayText type:ZJMessageModelTypeOther];
        
        //清空inputView的内容
        textView.text = nil;
        
        //发送完消息，inputView高度变回50
        self.inputViewHeightConstraint.constant = 50;
        
    }
    
}

/**
 *  发送内容
 */
- (void)sendMsgWithText:(NSString *)text type:(ZJMessageModelType)type{
    
    //创建消息模型
    ZJMessageModel *messageModel = [[ZJMessageModel alloc] init];
    //设置消息内容
    messageModel.text = text;
    messageModel.time = [self timeStrWithTimeDate:[NSDate date]];
    messageModel.type = type;
    
    //创建消息frame模型
    ZJMessageFrameModel *messageFrameModel = [[ZJMessageFrameModel alloc] init];
    //将消息模型赋值给messageFrameModel的消息模型
    messageFrameModel.messageModel = messageModel;
    [self.messageFrameModels addObject:messageFrameModel];
    
    //刷新表格
    [self.tableView reloadData];
    
    //自动滚动到表格底部
    [self scrollToTableBottom];
    
}

/**
 *  设置日期格式，并返回time字符串
 */
- (NSString *)timeStrWithTimeDate:(NSDate *)date{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //如果是真机调试，转换欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //设置日期格式（声明字符串里面每个数字和单词的含义）
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [fmt stringFromDate:date];
    
    return timeStr;
}

/**
 *  滚动到表格底部
 */
- (void)scrollToTableBottom{
    
    NSInteger lastRow = self.messageFrameModels.count - 1;
    if (lastRow < 0) {//如果行数小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/**
 *  自动回复消息
 *
 *  @param text "我"发送的消息内容
 *
 *  @return “别人”回复的消息内容
 */
- (NSString *)autoReplayWithText:(NSString *)text{

    for (int i = 0; i< text.length; i++) {
        
        //截取关键字
        NSString *subStr = [text substringWithRange:NSMakeRange(i, 1)];
        
        //将关键字与自动回复消息字典匹配
        if (self.autoReplay[subStr]) {
            return self.autoReplay[subStr];
        }
    }
    
    return @"留下你的留言信息，有空会回复!";
}



@end
