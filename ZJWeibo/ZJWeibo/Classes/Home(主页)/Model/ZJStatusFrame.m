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

#define ZJStatusCellBorderW 10

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
    CGFloat iconWH = 35;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + ZJStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:ZJStatusCellNameLableFont];
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
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + ZJStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:ZJStatusCellTimeLableFont];
    self.timeLabelF = (CGRect){{timeX, timeY},timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + ZJStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:ZJStatusCellSourceLableFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY},sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + ZJStatusCellBorderW;
    CGFloat maxW = cellW - 2 * ZJStatusCellBorderW;
    CGSize contentSize = [self sizeWithText:status.text font:ZJStatusCellContentLableFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY},contentSize};
    
    /** 配图 */
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalH = CGRectGetMaxY(self.contentLabelF) + ZJStatusCellBorderW;
    CGFloat originalW = cellW ;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
    
    
    
}


#pragma mark - 抽取的方法
/**
 *  计算文字的size
 *
 *  @param text 文字内容
 *  @param font 字体大小
 *  @param maxW 文字范围宽度
 *
 *  @return 文字的size
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}


@end
