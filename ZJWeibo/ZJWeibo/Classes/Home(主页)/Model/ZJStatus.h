//
//  ZJStatus.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/21.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  微博模型,存放微博相关信息

/*
 idstr	string	字符串型的微博ID
 text	string	微博信息内容
 user	object	微博作者的用户信息字段
 */

#import <Foundation/Foundation.h>
@class ZJUser;

@interface ZJStatus : NSObject

/** idstr string	字符串型的微博ID */
@property(nonatomic,copy) NSString *idstr;

/** text string	微博信息内容 */
@property(nonatomic,copy) NSString *text;

/** user	object	微博作者的用户信息字段 */
@property(nonatomic,strong) ZJUser *user;

@end
