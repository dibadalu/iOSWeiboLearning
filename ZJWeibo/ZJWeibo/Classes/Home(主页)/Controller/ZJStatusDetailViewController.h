//
//  ZJStatusDetailViewController.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/30.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJStatus;

@interface ZJStatusDetailViewController : UIViewController

/** 微博数据 */
@property(nonatomic,strong) ZJStatus *status;

@end
