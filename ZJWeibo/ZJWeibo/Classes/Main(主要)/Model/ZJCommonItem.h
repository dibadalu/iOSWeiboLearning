//
//  ZJCommonItem.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/3.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  用一个ZJCommonItem模型来描述每行的信息：图标、标题、子标题、右边的样式（箭头、文字、数字、开关、打钩）


#import <Foundation/Foundation.h>

@interface ZJCommonItem : NSObject
/** 图标 */
@property(nonatomic,copy) NSString *icon;
/** 标题 */
@property(nonatomic,copy) NSString *title;
/** 子标题 */
@property(nonatomic,copy) NSString *subTitle;
/** 右边显示的数字标识 */
@property(nonatomic,copy) NSString *badgeValue;
/** 目标控制器 */
@property(nonatomic,assign) Class destVcClass;
/** 用block封装点击item时所要执行的操作 copy属性 */
@property(nonatomic,copy) void (^operation)();


+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;

@end
