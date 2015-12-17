//
//  ZJMessageCell.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/17.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  自定义消息cell

#import <UIKit/UIKit.h>
@class ZJMessageFrameModel;

@interface ZJMessageCell : UITableViewCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

/** 消息frame模型 */
@property(nonatomic,strong) ZJMessageFrameModel *messageFrameModel;

@end
