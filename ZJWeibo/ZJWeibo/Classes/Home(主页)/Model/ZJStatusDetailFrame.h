//
//  ZJStatusDetailFrame.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/29.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJStatus;

@interface ZJStatusDetailFrame : NSObject

/** 微博数据 */
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

@end
