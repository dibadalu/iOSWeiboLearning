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
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.nameLabelF) + ZJStatusCellBorderW;
    CGFloat maxW = cellW - 3 * ZJStatusCellBorderW - iconWH;
    CGSize contentSize = [status.text sizeWithFont:ZJStatusCellContentLableFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY},contentSize};
    
    /** 配图 要考虑有无配图,会影响原创微博整体的高度*/
    CGFloat originalH = 0;
    if (status.pic_urls.count) {//有配图
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + ZJStatusCellBorderW;
        CGFloat photoWH = 80;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        
        originalH = CGRectGetMaxY(self.photoViewF) + ZJStatusCellBorderW;
    }else{//没有配图
        
        originalH = CGRectGetMaxY(self.contentLabelF) + ZJStatusCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW ;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    

    /* 转发微博 要考虑是否存在转发微博 */
    if (status.retweeted_status) {//存在转发微博
        //取出转发微博
        ZJStatus *retweeted_status = status.retweeted_status;
        //取出转发微博的用户
        ZJUser *retweeted_status_user = retweeted_status.user;

        /** 昵称+正文 */
        CGFloat retweetedContentX = ZJStatusCellBorderW;
        CGFloat retweetedContentY = ZJStatusCellBorderW;
        NSString *retweeted_text = [NSString stringWithFormat:@"%@:%@",retweeted_status_user.name,retweeted_status.text];
        CGFloat retweetedContentW = maxW - 2 * ZJStatusCellBorderW;
        CGSize retweetedContentSize = [retweeted_text sizeWithFont:ZJRetweetedStatusCellContentLableFont maxW:retweetedContentW];
        self.retweetedContentLabelF = (CGRect){{retweetedContentX,retweetedContentY},retweetedContentSize};
        
        /** 配图 要考虑是否有配图*/
        CGFloat retweetedH = 0;
        if (retweeted_status.pic_urls.count) {//有配图
            CGFloat retweetedPhotoX = retweetedContentX;
            CGFloat retweetedPhotoY = CGRectGetMaxY(self.retweetedContentLabelF) + ZJStatusCellBorderW;
            CGFloat retweetedPhotoWH = 80;
            self.retweetedPhotoViewF = CGRectMake(retweetedPhotoX, retweetedPhotoY, retweetedPhotoWH, retweetedPhotoWH);
        
            retweetedH = CGRectGetMaxY(self.retweetedPhotoViewF) + ZJStatusCellBorderW;
        }else{//没配图
            
            retweetedH = CGRectGetMaxY(self.retweetedContentLabelF) + ZJStatusCellBorderW;
        }

        
        /** 转发微博整体 */
        CGFloat retweetedX = contentX;
        CGFloat retweetedY = CGRectGetMaxY(self.originalViewF) + ZJStatusCellBorderW;
        CGFloat retweetedW = cellW - 3 * ZJStatusCellBorderW - iconWH;
        self.retweetedViewF = CGRectMake(retweetedX, retweetedY, retweetedW, retweetedH);
        
        /** cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.retweetedViewF);
        
    }else{//没转发微博
        
        /** cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.originalViewF);
    }


    /** 来源 */
    //    CGFloat sourceX = nameX;
    //    CGFloat sourceY = CGRectGetMaxY(self.nameLabelF) + ZJStatusCellBorderW;
    //    CGSize sourceSize = [status.source sizeWithFont:ZJStatusCellSourceLableFont];
    //    self.sourceLabelF = (CGRect){{sourceX, sourceY},sourceSize};
}






@end
