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
#import "ZJStatusPhotosView.h"

@implementation ZJStatusFrame
/**
 *  计算原创微博的frame
 *
 *  @param status 微博模型
 */
- (void)setupOriginalFrame:(ZJStatus *)status
{
    _status = status;
    
    
    //取出用户模型
    ZJUser *user = status.user;
    
    /**  原创微博 */
    
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
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + ZJStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:ZJStatusCellTimeLableFont];
    self.timeLabelF = (CGRect){{timeX, timeY},timeSize};
    
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + ZJStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:ZJStatusCellSourceLableFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY},sourceSize};
    
    /** 正文 */
    CGFloat contentX = ZJStatusCellBorderW;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + ZJStatusCellBorderW;
    CGFloat maxW = ZJScreenW - 2 * ZJStatusCellBorderW;
    CGSize contentSize = [status.attributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF = (CGRect){{contentX, contentY},contentSize};
    
    
    /** 配图 要考虑有无配图,会影响原创微博整体的高度*/
    CGFloat originalH = 0;
    if (status.pic_urls.count) {//有配图
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + ZJStatusCellBorderW;
        CGSize photosSize = [ZJStatusPhotosView sizeWithPhotosCount:status.pic_urls.count];
        self.photosViewF = (CGRect){{photosX,photosY},photosSize};
        
        originalH = CGRectGetMaxY(self.photosViewF) + ZJStatusCellBorderW;
    }else{//没有配图
        
        originalH = CGRectGetMaxY(self.contentLabelF) + ZJStatusCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = ZJScreenW ;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
}


/**
 *  计算转发微博的frame
 *
 *  @param retweetedStatus <#retweetedStatus description#>
 */
- (void)setupRetweetedFrame:(ZJStatus *)status
{
    _status = status;
    
    //取出转发微博
    ZJStatus *retweeted_status = status.retweeted_status;
    
    /** 昵称+正文 */
    CGFloat retweetedContentX = ZJStatusCellBorderW;
    CGFloat retweetedContentY = ZJStatusCellBorderW;
    CGFloat retweetedContentW = ZJScreenW - 4 * ZJStatusCellBorderW;
    CGSize retweetedContentSize = [status.retweeted_attributedText boundingRectWithSize:CGSizeMake(retweetedContentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.retweetedContentLabelF = (CGRect){{retweetedContentX,retweetedContentY},retweetedContentSize};
    
    /** 配图 要考虑是否有配图*/
    CGFloat retweetedH = 0;
    if (retweeted_status.pic_urls.count) {//有配图
        CGFloat retweetedPhotosX = retweetedContentX;
        CGFloat retweetedPhotosY = CGRectGetMaxY(self.retweetedContentLabelF) + ZJStatusCellBorderW;
        CGSize retweetedPhotosSize = [ZJStatusPhotosView sizeWithPhotosCount:retweeted_status.pic_urls.count];
        self.retweetedPhotosViewF = (CGRect){{retweetedPhotosX,retweetedPhotosY},retweetedPhotosSize};
        
        retweetedH = CGRectGetMaxY(self.retweetedPhotosViewF) + ZJStatusCellBorderW;
    }else{//没配图
        
        retweetedH = CGRectGetMaxY(self.retweetedContentLabelF) + ZJStatusCellBorderW;
    }

    /** 转发微博整体 */
    CGFloat retweetedX = ZJStatusCellBorderW;
    CGFloat retweetedY = CGRectGetMaxY(self.originalViewF) + ZJStatusCellBorderW;
    CGFloat retweetedW = ZJScreenW - 2 * ZJStatusCellBorderW;
    self.retweetedViewF = CGRectMake(retweetedX, retweetedY, retweetedW, retweetedH);

}

/**
 *  计算cell子控件的frame和cell的高度
 *
 *  @param status 微博模型
 */
- (void)setStatus:(ZJStatus *)status
{
    _status = status;
    
    //1.计算原创微博的frame
    [self setupOriginalFrame:status];
    
    //2.计算转发微博的frame
    CGFloat toolBarY = 0;
    if (status.retweeted_status) {//存在转发微博
        
        [self setupRetweetedFrame:status];
        toolBarY = CGRectGetMaxY(self.retweetedViewF);
    }else{//没转发微博
        toolBarY = CGRectGetMaxY(self.originalViewF);
    }
    
    //3.工具条
    CGFloat toolBarX = 0;
    CGFloat toolBarW = ZJScreenW ;
    CGFloat toolBarH = 30;
    self.toolBarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    
    //4.cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolBarF);
    
    
}







@end
