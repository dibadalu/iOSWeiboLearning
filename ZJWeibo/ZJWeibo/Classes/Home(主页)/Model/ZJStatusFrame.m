//
//  ZJStatusFrame.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusFrame.h"
#import "ZJUser.h"
#import "ZJStatus.h"



@implementation ZJStatusFrame

/**
 *  计算cell子控件的frame和cell的高度
 *
 *  @param status 微博模型
 */
- (void)setStatus:(ZJStatus *)status
{
    _status = status;
    
    //取出用户模型
    ZJUser *user = status.user;
    
    //屏幕的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconX = ZJStatusCellBorderW;
    CGFloat iconY = ZJStatusCellBorderW;
    CGFloat iconWH = 30;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + ZJStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:ZJStatusCellNameLableFont];
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    
    /** 会员图标 */
    if (user.vip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + ZJStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }

    /** 时间 */
    CGSize timeSize = [status.created_at sizeWithFont:ZJStatusCellTimeLableFont];
    CGFloat timeX = cellW - ZJStatusCellBorderW - timeSize.width;
    CGFloat timeY = nameY;
    self.timeLabelF = (CGRect){{timeX, timeY},timeSize};

    /** 正文 */
//    CGFloat contentX = iconX;
//    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + ZJStatusCellBorderW;
//    CGFloat maxW = cellW - 2 * ZJStatusCellBorderW;
//    CGSize contentSize = [status.text sizeWithFont:ZJStatusCellContentLableFont maxW:maxW];
//    self.contentLabelF = (CGRect){{contentX, contentY},contentSize};
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.nameLabelF) + ZJStatusCellBorderW;
    CGFloat maxW = cellW - 2 * ZJStatusCellBorderW - iconWH;
    CGSize contentSize = [status.text sizeWithFont:ZJStatusCellContentLableFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY},contentSize};
    
    /** 配图 */
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalH = CGRectGetMaxY(self.contentLabelF) + ZJStatusCellBorderW;
    CGFloat originalW = cellW ;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    /** 来源 */
//    CGFloat sourceX = nameX;
//    CGFloat sourceY = CGRectGetMaxY(self.nameLabelF) + ZJStatusCellBorderW;
//    CGSize sourceSize = [status.source sizeWithFont:ZJStatusCellSourceLableFont];
//    self.sourceLabelF = (CGRect){{sourceX, sourceY},sourceSize};
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
    
    
    
}






@end
