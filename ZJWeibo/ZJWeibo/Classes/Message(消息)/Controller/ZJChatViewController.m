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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"聊天界面";
    
    //初始化界面
    [self setupMsgView];
  
    
}

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




@end
