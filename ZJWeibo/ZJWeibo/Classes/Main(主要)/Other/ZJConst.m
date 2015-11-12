//
//  ZJConst.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  全局静态常量

#import <Foundation/Foundation.h>

//账号信息
NSString * const ZJAppKey = @"2053650830";
NSString * const ZJRedirctURI = @"http://www.baidu.com";
NSString * const ZJAppSecret = @"75938468eecb498878db62066ed75b1e";

//表情文字的通知
NSString * const ZJSelectEmotion = @"selectEmotion";
NSString * const ZJEmotionDidSelectNotification = @"HMEmotionDidSelectNotification";
//删除文字的通知
NSString * const ZJEmotionDidDeleteNotification = @"HMEmotionDidDeleteNotification";
//链接的通知
NSString * const ZJSpecialTextDidSelectNotification =@"ZJSpecialTextDidSelectNotification";
//特殊字符出现的文本内容
NSString * const ZJSpecialTextDidSelectText = @"ZJSpecialTextDidSelectText";
//ZJProfileHeaderBottomView的按钮被点击的通知
NSString * const ZJProfileHeaderBottomViewBtnDidSelectNotification = @"ZJProfileHeaderBottomViewBtnDidSelectNotification";
//ZJProfileHeaderBottomView的按钮被点击的按钮类型
NSString * const ZJSelectProfileHeaderBottomViewBtnType = @"selectProfileHeaderBottomViewBtnType";
