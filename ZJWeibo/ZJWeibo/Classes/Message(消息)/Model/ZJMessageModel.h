//
//  ZJMessageModel.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/12/17.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  消息模型

#import <Foundation/Foundation.h>

typedef enum {
    ZJMessageModelTypeMe = 0,//自己
    ZJMessageModelTypeOther
}ZJMessageModelType;

@interface ZJMessageModel : NSObject

/** 正文 */
@property(nonatomic,copy) NSString *text;

/** 时间 */
@property(nonatomic,copy) NSString *time;

/** 发送类型 */
@property(nonatomic,assign) ZJMessageModelType type;

/** 是否隐藏时间 */
@property(nonatomic,assign) BOOL hideTime;

/** 字典转模型 */
- (instancetype)initWithDict:(NSDictionary *)dict;
/** 字典转模型的工厂方法 */
+ (instancetype)messageWithDict:(NSDictionary *)dict;



@end
