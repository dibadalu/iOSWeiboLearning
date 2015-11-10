//
//  ZJProfileDetailViewController.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJAccount;

@interface ZJProfileDetailViewController : UIViewController

/** 账号模型 */
@property(nonatomic,strong) ZJAccount *account;

@end
