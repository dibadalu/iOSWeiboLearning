//
//  ZJMessageFrameModel.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/17.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// 消息frame模型

#import <Foundation/Foundation.h>
@class ZJMessageModel;


#define ZJMessageTimeFont [UIFont systemFontOfSize:13.0f]
#define ZJMessageContentFont [UIFont systemFontOfSize:15.0f]

@interface ZJMessageFrameModel : NSObject

/** 消息模型 */
@property(nonatomic,strong) ZJMessageModel *messageModel;

/** 所有子控件的frame */
//时间
@property(nonatomic,assign,readonly) CGRect timeLabelF;

//头像
@property(nonatomic,assign,readonly) CGRect iconF;

//正文
@property(nonatomic,assign,readonly) CGRect contentBtnF;

/** cell的高度 */
@property(nonatomic,assign,readonly) CGFloat cellHeight;


@end
