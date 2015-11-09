//
//  ZJProfileHeaderView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  profile的tableHeaderView

#import <UIKit/UIKit.h>
@class ZJAccount,ZJInfoCount;

@interface ZJProfileHeaderView : UIView

/** 账号模型 */
@property(nonatomic,strong) ZJAccount *account;
/** ZJInfoCount模型 */
@property(nonatomic,strong) ZJInfoCount *infoCount;
@end
