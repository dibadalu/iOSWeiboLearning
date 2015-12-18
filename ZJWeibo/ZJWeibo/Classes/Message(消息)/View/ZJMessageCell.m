//
//  ZJMessageCell.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/17.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJMessageCell.h"
#import "ZJMessageFrameModel.h"
#import "ZJMessageModel.h"



@interface ZJMessageCell ()

//时间
@property(nonatomic,weak) UILabel *timeLabel;

//头像
@property(nonatomic,weak) UIImageView *icon;

//正文
@property(nonatomic,weak) UIButton *contentBtn;

@end

@implementation ZJMessageCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"MessageCell";
    ZJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZJMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        [self setupChirdView];
    }
    return self;
}

- (void)setupChirdView{
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = ZJMessageTimeFont;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //头像
    UIImageView *icon = [[UIImageView alloc] init];
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    //正文
    UIButton *contentBtn = [[UIButton alloc] init];
    contentBtn.titleLabel.font = ZJMessageContentFont;
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.titleLabel.numberOfLines = 0;//换行
    contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 20);
    [self.contentView addSubview:contentBtn];
    self.contentBtn = contentBtn;
    
    
}

/**
 *  根据外界传进来的消息frame模型设置子控件的frame，根据消息模型设置数据
 *
 *  @param messageFrameModel 消息frame模型
 */
- (void)setMessageFrameModel:(ZJMessageFrameModel *)messageFrameModel{
    
    _messageFrameModel = messageFrameModel;
    //取出消息模型
    ZJMessageModel *messageModel = messageFrameModel.messageModel;
    
    //时间
    self.timeLabel.frame = messageFrameModel.timeLabelF;
    self.timeLabel.text = messageModel.time;
    
    
    //头像
    self.icon.frame = messageFrameModel.iconF;
    if (messageModel.type == ZJMessageModelTypeMe) {//我
        self.icon.image = [UIImage imageNamed:@"suoluobg"];
    }else{
        self.icon.image = [UIImage imageNamed:@"messagescenter_chat"];
    }
    
    //正文
    self.contentBtn.frame = messageFrameModel.contentBtnF;
    [self.contentBtn setTitle:messageModel.text forState:UIControlStateNormal];
    
    //设置消息正文背景
    if (messageModel.type == ZJMessageModelTypeMe) {//我

        [self.contentBtn setBackgroundImage:[UIImage resizedImageName:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
    }else{
        [self.contentBtn setBackgroundImage:[UIImage resizedImageName:@"ReceiverAppNodeBkg"] forState:UIControlStateNormal];
    }
    
    
}



@end
