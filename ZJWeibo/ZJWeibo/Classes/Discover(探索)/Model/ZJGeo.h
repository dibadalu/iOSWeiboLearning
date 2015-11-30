//
//  ZJGeo.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/11/30.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 longitude	string	经度坐标
 latitude	string	维度坐标
 city	string	所在城市的城市代码
 province	string	所在省份的省份代码
 city_name	string	所在城市的城市名称
 province_name	string	所在省份的省份名称
 */

@interface ZJGeo : NSObject

/** 经度坐标 */
@property(nonatomic,copy) NSString *longitude;

/** 纬度坐标 */
@property(nonatomic,copy) NSString *latitude;

/** 所在城市的城市名称 */
@property(nonatomic,copy) NSString *city_name;


@end
