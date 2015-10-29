//
//  ZJStatusToolBar.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  微博工具条，要存放一个微博模型,用于获取转发数评论数表态数
/*
 reposts_count	int	转发数
 comments_count	int	评论数
 attitudes_count	int	表态数
 */

#import <UIKit/UIKit.h>
@class ZJStatus;

@interface ZJStatusToolBar : UIView

/** 微博模型 */
@property(nonatomic,strong) ZJStatus *status;

+ (instancetype)tooBar;


@end
