//
//  ZJStatusFrame.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusFrame.h"
#import "ZJStatus.h"
#import "ZJStatusDetailFrame.h"

@implementation ZJStatusFrame


/**
 *  计算cell子控件的frame和cell的高度
 *
 *  @param status 微博模型
 */
- (void)setStatus:(ZJStatus *)status
{
    _status = status;
    
    //1.微博整体内容
    ZJStatusDetailFrame *detailFrame = [[ZJStatusDetailFrame alloc] init];
    detailFrame.status = status;
    self.detailFrame = detailFrame;
       
    //2.工具条
    CGFloat toolBarY = 0;
    if (status.retweeted_status) {//存在转发微博
        
        toolBarY = CGRectGetMaxY(detailFrame.retweetedViewF);
    }else{//没转发微博
        toolBarY = CGRectGetMaxY(detailFrame.originalViewF);
    }
    CGFloat toolBarX = 0;
    CGFloat toolBarW = ZJScreenW ;
    CGFloat toolBarH = 30;
    self.toolBarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    
    //3.cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolBarF);
    
    
}







@end
