//
//  ZJUser.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// 用户模型，存放从新浪服务器获得的与用户相关的数据

#warning 注意所有模型的属性名称要保证与服务器的名称一致
#import <Foundation/Foundation.h>


@interface ZJUser : NSObject

/** idstr string	字符串型的用户UID */
@property(nonatomic,copy) NSString *idstr;

/** name	string	昵称 */
@property(nonatomic,copy) NSString *name;

/** profile_image_url	string	用户头像地址（中图），50×50像素 */
@property(nonatomic,copy) NSString *profile_image_url;



@end
