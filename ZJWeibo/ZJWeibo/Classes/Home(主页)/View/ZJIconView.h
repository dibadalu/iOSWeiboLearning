//
//  ZJIconView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJUser;

@interface ZJIconView : UIImageView

/** 用户模型 */
@property(nonatomic,strong) ZJUser *user;

@end
