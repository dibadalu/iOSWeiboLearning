//
//  ZJProfileHeaderBottomView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJUser;

@interface ZJProfileHeaderBottomView : UIView

/** 类方法 */
+ (instancetype)headerBottomView;

/** 用户模型 */
@property(nonatomic,strong) ZJUser *user;

@end
