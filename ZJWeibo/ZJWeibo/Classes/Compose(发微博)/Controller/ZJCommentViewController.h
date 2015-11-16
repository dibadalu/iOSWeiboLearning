//
//  ZJCommentViewController.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/16.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJStatus;

@interface ZJCommentViewController : UIViewController

/** 微博数据 */
@property(nonatomic,strong) ZJStatus *status;

@end
