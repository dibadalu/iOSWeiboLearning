//
//  ZJStatusFrame.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  微博frame模型,负责计算cell子控件的frame和cell的高度



#import <Foundation/Foundation.h>
@class ZJStatus,ZJStatusDetailFrame;

@interface ZJStatusFrame : NSObject

/** 微博模型ZJStatus */
@property(nonatomic,strong) ZJStatus *status;
/** 微博整体frame数据 */
@property(nonatomic,strong) ZJStatusDetailFrame *detailFrame;

/** 工具条 */
@property(nonatomic,assign) CGRect toolBarF;

/** cell的高度 */
@property(nonatomic,assign) CGFloat cellHeight;


@end
