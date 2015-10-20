//
//  AFJSONResponseSerializer+ZJ.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// 由于新浪返回的数据content-Type是text/plain，所以在[AFJSONResponseSerializer serializer]加上text/plain类型，重写init方法

#import <AFNetworking/AFNetworking.h>

@interface AFJSONResponseSerializer (ZJ)

- (instancetype)init ;

@end
