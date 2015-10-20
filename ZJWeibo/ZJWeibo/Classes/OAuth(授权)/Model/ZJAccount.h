//
//  ZJAccount.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  利用code所获得账号信息

/*
 access_token	string	 用于调用access_token，接口获取授权后的access token。
 expires_in	    string	access_token的生命周期，单位是秒数。
 remind_in	    string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
 uid	        string	当前授权用户的UID。
 */

#import <Foundation/Foundation.h>

@interface ZJAccount : NSObject <NSCoding>//遵守NSCoding协议

/** string	用于调用access_token，接口获取授权后的access token */
@property(nonatomic,copy) NSString *access_token;

/** string	access_token的生命周期，单位是秒数 */
@property(nonatomic,copy) NSString *expires_in;

/** string	当前授权用户的UID */
@property(nonatomic,copy) NSString *uid;

/** access token的创建时间 */
@property(nonatomic,strong) NSDate *created_time;

/** 用户的昵称 */
@property(nonatomic,copy) NSString *name;


+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
