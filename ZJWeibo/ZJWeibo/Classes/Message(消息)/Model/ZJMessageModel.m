//
//  ZJMessageModel.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/17.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJMessageModel.h"

@implementation ZJMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}
+ (instancetype)messageWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

@end
