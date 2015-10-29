//
//  ZJStatusFrame.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  微博frame模型,负责计算cell子控件的frame和cell的高度





#import <Foundation/Foundation.h>
@class ZJStatus;

@interface ZJStatusFrame : NSObject

/** 微博模型ZJStatus */
@property(nonatomic,strong) ZJStatus *status;


/* 原创微博 */
/** 原创微博整体 */
@property(nonatomic,assign) CGRect originalViewF;
/** 头像 */
@property(nonatomic,assign) CGRect iconViewF;
/** 会员图标 */
@property(nonatomic,assign) CGRect vipViewF;
/** 配图 */
@property(nonatomic,assign) CGRect photosViewF;
/** 昵称 */
@property(nonatomic,assign) CGRect nameLabelF;
/** 时间 */
@property(nonatomic,assign) CGRect timeLabelF;
/** 来源 */
@property(nonatomic,assign) CGRect sourceLabelF;
/** 正文 */
@property(nonatomic,assign) CGRect contentLabelF;


/* 转发微博 */
/** 转发微博整体 */
@property(nonatomic,assign) CGRect retweetedViewF;
/** 配图 */
@property(nonatomic,assign) CGRect retweetedPhotosViewF;
/** 昵称+正文 */
@property(nonatomic,assign) CGRect retweetedContentLabelF;

/** 工具条 */
@property(nonatomic,assign) CGRect toolBarF;

/** cell的高度 */
@property(nonatomic,assign) CGFloat cellHeight;


@end
