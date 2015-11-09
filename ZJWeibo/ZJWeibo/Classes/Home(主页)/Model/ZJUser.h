//
//  ZJUser.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// 用户模型，存放从新浪服务器获得的与用户相关的数据

#warning 注意所有模型的属性名称要保证与服务器的名称一致

typedef enum {
    ZJUserVerifiedTypeNone = -1, // 没有任何认证
    
    ZJUserVerifiedPersonal = 0,  // 个人认证
    
    ZJUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    ZJUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    ZJUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    ZJUserVerifiedDaren = 220 // 微博达人
} ZJUserVerifiedType;


#import <Foundation/Foundation.h>


@interface ZJUser : NSObject

/** 字符串型的用户UID */
@property(nonatomic,copy) NSString *idstr;

/** 昵称 */
@property(nonatomic,copy) NSString *name;

/** 用户头像地址（中图），50×50像素 */
@property(nonatomic,copy) NSString *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic, assign) int mbrank;

/** 是否是会员 */
@property (nonatomic, assign, getter = isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) ZJUserVerifiedType verified_type;


@end
