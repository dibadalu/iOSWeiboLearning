//
//  ZJMessageFrameModel.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/17.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJMessageFrameModel.h"
#import "ZJMessageModel.h"

#define ZJMessageTimeH 44 //时间高度
#define ZJMessageIconW 50 //头像宽度

@implementation ZJMessageFrameModel


/**
 *  根据外界传进来的消息模型设置各子控件的frame
 *
 *  @param messageModel 消息模型
 */
- (void)setMessageModel:(ZJMessageModel *)messageModel{
    
    //存消息模型
    _messageModel = messageModel;
    
    CGFloat padding = 10;
    
    
    //时间frame
    if (messageModel.hideTime == NO) {//显示时间
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = ZJScreenW;
        CGFloat timeH = ZJMessageTimeH;
        
        _timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    //头像frame
    CGFloat iconW = ZJMessageIconW;
    CGFloat iconH = iconW;
    CGFloat iconY = CGRectGetMaxY(_timeLabelF) + padding;
    CGFloat iconX = 0;
    if (messageModel.type == ZJMessageModelTypeMe) {//自己发的
        iconX = ZJScreenW - padding - iconW;
    }else{//别人发的
        iconX = padding;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    //正文frame
    CGFloat contentX = 0;
    CGFloat contentY = iconY + padding;
    //设置正文的size
    CGSize contentMaxSize = CGSizeMake(150, MAXFLOAT);
    CGSize contentRealSize = [messageModel.text boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ZJMessageContentFont} context:nil].size;
    CGSize btnSize = CGSizeMake(contentRealSize.width + 40, contentRealSize.height + 30);
    if (messageModel.type == ZJMessageModelTypeMe) {//自己发的
        contentX = ZJScreenW - padding * 2 - iconW - btnSize.width;
        
    }else{//别人发的
        contentX = iconW + padding * 2;
    }
    _contentBtnF = (CGRect){{contentX,contentY},btnSize};
    
    //cell的高度
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    CGFloat contentMaxY = CGRectGetMaxY(_contentBtnF);
    _cellHeight = MAX(iconMaxY, contentMaxY);
    
   
}

@end
