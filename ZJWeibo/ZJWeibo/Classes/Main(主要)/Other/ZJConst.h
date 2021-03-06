//
//  ZJConst.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>

//账号信息
extern NSString * const ZJAppKey;
extern NSString * const ZJRedirctURI;
extern NSString * const ZJAppSecret;

//表情文字的通知
extern NSString * const ZJSelectEmotion;
extern NSString * const ZJEmotionDidSelectNotification;
//删除文字的通知
extern NSString * const ZJEmotionDidDeleteNotification;
//链接选中的通知
extern NSString * const ZJSpecialTextDidSelectNotification;
//特殊字符出现的文本内容
extern NSString * const ZJSpecialTextDidSelectText;
//ZJProfileHeaderBottomView的按钮被点击的通知
extern NSString * const ZJProfileHeaderBottomViewBtnDidSelectNotification;
//ZJProfileHeaderBottomView的按钮被点击的按钮类型
extern NSString * const ZJSelectProfileHeaderBottomViewBtnType;
